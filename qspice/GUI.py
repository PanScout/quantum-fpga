import numpy as np
from PyQt5.QtWidgets import (
    QApplication, QMainWindow, QToolBar, QPushButton, QWidget, QSizePolicy, 
    QDialog, QGridLayout, QLineEdit, QDialogButtonBox, QLabel, 
    QGraphicsDropShadowEffect, QGraphicsScene, QGraphicsView, QGraphicsTextItem, 
    QGraphicsEllipseItem, QGraphicsRectItem, QGraphicsLineItem, 
    QSpinBox, QHBoxLayout, QVBoxLayout, QGroupBox, QFormLayout, QComboBox
)
from PyQt5.QtCore import Qt, QMimeData, QTimer, pyqtSignal
from PyQt5.QtGui import QDrag, QPainter, QPen, QColor, QFont, QFontDatabase, QPalette, QBrush
from enum import Enum
import matplotlib.pyplot as plt
from QSPICE import * 
from scipy.ndimage import gaussian_filter1d


RUN_ON_HARDWARE = True
# ------------------------------------------------------------------------------
# Define Coffee Theme color constants
# ------------------------------------------------------------------------------
COLORS = {
            'background': '#F5E6D3',   # Light cream
            'surface': '#6F4E37',      # Coffee brown
            'toolbar': '#6B4423',      # Mocha A67B5B
            'primary': '#8B4513',      # Saddle brown
            'secondary': '#D2691E',    # Chocolate
            'shadow': 'rgba(111, 78, 55, 0.3)',  # Coffee shadow
            'on_background': '#F5E6D3', # Dark roast
        
            'on_surface': '#FFF8DC',    # Cornsilk
            'on_primary': '#FFF8DC',    # Cornsilk
            'on_secondary': '#FFF8DC',  # Cornsilk
            'on_error': '#FFF8DC',      # Cornsilk
            'error': '#C41E3A',         # Cardinal red
            'button': {
                'normal': '#8B4513',    # Saddle brown
                'hover': '#A0522D',     # Sienna
                'active': '#6B4423',    # Darker brown
                'clear': '#C41E3A'      # Cardinal red
            },
            'gate': {
                'H': '#D2691E',         # Chocolate
                'X': '#CD853F',         # Peru
                'Y': '#DEB887',         # Burlywood
                'Z': '#D2B48C',         # Tan
                'CNOT': '#8B4513',      # Saddle brown
                'Custom': '#A0522D'     # Sienna
            },
            'qubit_line': '#6F4E37'     # Coffee brown
        }

class QuantumGateWidget(QLabel):
    def __init__(self, gate_type, parent=None):
        super().__init__(parent)
        self.gate_type = gate_type
        self.setFixedSize(90, 45)  # Slightly larger for better visibility
        self.setAlignment(Qt.AlignCenter)
        
        # Coffee-themed style with improved visibility
        self.setStyleSheet(f"""
            background-color: {COLORS['gate'].get(gate_type, COLORS['primary'])};
            color: {COLORS['on_primary']};
            border-radius: 8px;
            border: 1px solid {COLORS['surface']};
            border-bottom: 3px solid {COLORS['surface']};
            font-family: 'Palatino', 'Times New Roman', serif;
            font-weight: 700;
            font-size: 18px;
            text-transform: uppercase;
            letter-spacing: 1px;
        """)
        self.setText(gate_type)
        self.setCursor(Qt.OpenHandCursor)
        
        # Enhanced coffee-themed elevation
        self.effect = QGraphicsDropShadowEffect()
        self.effect.setBlurRadius(8)
        self.effect.setOffset(0, 3)
        self.effect.setColor(QColor(COLORS['shadow']))
        self.setGraphicsEffect(self.effect)

    def mouseMoveEvent(self, event):
        """Initiate a drag action when the user moves the mouse with left button pressed."""
        if event.buttons() != Qt.LeftButton:
            return
        drag = QDrag(self)
        mime = QMimeData()
        mime.setText(self.gate_type)
        drag.setMimeData(mime)
        
        # Create a semi-transparent pixmap for drag feedback
        pixmap = self.grab().scaled(60, 30)
        painter = QPainter(pixmap)
        painter.setCompositionMode(QPainter.CompositionMode_DestinationIn)
        painter.fillRect(pixmap.rect(), QColor(255, 255, 255, 180))
        painter.end()
        drag.setPixmap(pixmap)
        drag.setHotSpot(event.pos())
        drag.exec_(Qt.CopyAction)

# ------------------------------------------------------------------------------
# CircuitScene: Custom QGraphicsScene for laying out the quantum circuit
# ------------------------------------------------------------------------------
class CircuitScene(QGraphicsScene):
    gate_placed = pyqtSignal(int, int, int, str)
    gate_removed = pyqtSignal(int, int, int)  # New signal for gate removal
    error_occurred = pyqtSignal(str)
    message_emitted = pyqtSignal(str)  # New signal for informational messages
    custom_gate_requested = pyqtSignal(int, int)

    def __init__(self, num_qubits, num_layers):
        super().__init__()
        self.num_qubits = num_qubits
        self.num_layers = num_layers
        self.grid_size = 100  # Size of each grid cell
        self.left_margin = 60
        self.cnot_layers = set()  # Track layers with CNOT
        self.pending_cnot = None  # Store CNOT control selection
        self.temp_items = []
        self.highlight_items = []  # Store highlight elements
        self.drag_in_progress = False  # Track if a gate is being dragged
        self.drag_source = None  # Track source position of dragged gate
        self.trash_zone_visible = False  # Track if trash zone is visible
        self.trash_zone = None  # Reference to trash zone visual
        self.current_highlight = None  # Track current highlighted position
        self.init_grid()
        self.gate_positions = {}
        
        # Set scene dimensions
        self.setSceneRect(0, 0, 
                         self.left_margin + self.grid_size * self.num_layers,
                         self.grid_size * self.num_qubits)
        self.setBackgroundBrush(QColor(COLORS["background"]))

    def init_grid(self):
        """Draw the grid lines for qubit wires and layer barriers."""
        line_pen = QPen(QColor(COLORS['qubit_line']), 2, Qt.SolidLine)
        label_font = QFont("Roboto", 14)
        label_font.setWeight(QFont.Medium)
        
        # Draw horizontal lines for each qubit with improved visibility
        for q in range(self.num_qubits):
            y = q * self.grid_size + self.grid_size // 2
            line = self.addLine(self.left_margin, y, 
                              self.left_margin + self.grid_size * self.num_layers, y, 
                              line_pen)
            
            # Add subtle gradient to the line for better visibility
            line.setOpacity(0.8)
            
            # Create qubit label with subscript (q₀, q₁, etc.)
            subscripts = "₀₁₂₃₄₅₆₇₈₉"
            if q < 10:
                label_text = f"q{subscripts[q]}"
            else:
                subscript_text = ''.join(subscripts[int(digit)] for digit in str(q))
                label_text = f"q{subscript_text}"
                
            label = QGraphicsTextItem(label_text)
            label.setDefaultTextColor(QColor(COLORS['toolbar']))
            label.setFont(label_font)
            label.setPos(10, y - 15)
            
            # Add subtle shadow to the label
            label_shadow = QGraphicsDropShadowEffect()
            label_shadow.setBlurRadius(4)
            label_shadow.setOffset(1, 1)
            label_shadow.setColor(QColor(0, 0, 0, 50))
            label.setGraphicsEffect(label_shadow)
            
            self.addItem(label)
        
        # Draw vertical dashed barriers between layers with improved visibility
        barrier_pen = QPen(QColor(COLORS['qubit_line']), 1, Qt.DashLine)
        barrier_pen.setDashPattern([5, 5])  # More visible dash pattern
        for layer in range(1, self.num_layers):
            x = self.left_margin + layer * self.grid_size
            line = self.addLine(x, 0, x, self.grid_size * self.num_qubits, barrier_pen)
            line.setOpacity(0.6)  # Slightly transparent for better visual hierarchy

    def dragMoveEvent(self, event):
        """Accept drag move events and show trash zone if gate is being dragged out of circuit."""
        event.acceptProposedAction()
        
        # If this is a drag of an existing gate (not from palette)
        if self.drag_in_progress:
            pos = event.scenePos()
            x = pos.x() - self.left_margin
            y = pos.y()
            
            # Check if drag is moving outside the grid area
            outside_grid = (x < 0 or x >= self.num_layers * self.grid_size or 
                           y < 0 or y >= self.num_qubits * self.grid_size)
            
            # Show trash zone if dragging outside grid
            if outside_grid and not self.trash_zone_visible:
                self.show_trash_zone()
            elif not outside_grid and self.trash_zone_visible:
                self.hide_trash_zone()
                
            # Show visual feedback for move target in circuit
            if not outside_grid:
                col = int(x // self.grid_size)
                row = int(y // self.grid_size)
                self.highlight_target_cell(row, col)
            else:
                self.clear_highlights()

    def dragLeaveEvent(self, event):
        """Handle drag leaving the scene."""
        super().dragLeaveEvent(event)
        if self.trash_zone_visible:
            self.hide_trash_zone()

    def show_trash_zone(self):
        """Show a visual indicator for the trash/delete zone."""
        try:
            if self.trash_zone is None:
                # Create trash zone visuals
                width = self.sceneRect().width()
                height = 60
                
                # Background
                self.trash_zone = QGraphicsRectItem(0, -height, width, height)
                self.trash_zone.setBrush(QColor(255, 0, 0, 80))  # Semi-transparent red
                self.trash_zone.setPen(QPen(Qt.NoPen))
                self.trash_zone.setZValue(100)  # Ensure it's on top
                
                # Text
                text = QGraphicsTextItem("Drop here to delete")
                text.setDefaultTextColor(QColor('#FFFFFF'))
                text.setFont(QFont("Roboto", 14, QFont.Bold))
                text.setPos((width - text.boundingRect().width()) / 2, -height + 15)
                text.setZValue(101)
                
                # Add to scene
                self.addItem(self.trash_zone)
                self.addItem(text)
                self.trash_zone_items = [self.trash_zone, text]
            
            # Make the trash zone visible
            for item in self.trash_zone_items:
                item.setVisible(True)
            self.trash_zone_visible = True
        except Exception as e:
            # Log the error but continue execution
            print(f"Error showing trash zone: {e}")
            # Don't show the trash zone if there's an error
            self.trash_zone_visible = False

    def hide_trash_zone(self):
        """Hide the trash zone visual indicator."""
        if self.trash_zone is not None:
            for item in self.trash_zone_items:
                item.setVisible(False)
        self.trash_zone_visible = False
        
    def highlight_target_cell(self, row, col):
        """Show visual highlight for the target cell during a move operation."""
        # Skip if trying to highlight current position or invalid position
        if (self.current_highlight == (row, col) or 
            not (0 <= row < self.num_qubits and 0 <= col < self.num_layers)):
            return
            
        # Clear previous highlight
        self.clear_highlights()
        
        # Don't highlight if this position has a gate already, unless it's the source
        if (row, col) in self.gate_positions and (row, col) != self.drag_source:
            return
            
        # Get position for the highlight rectangle
        x = self.left_margin + col * self.grid_size + 5
        y = row * self.grid_size + 5
        width = self.grid_size - 10
        height = self.grid_size - 10
        
        # Create highlight rectangle
        highlight = QGraphicsRectItem(x, y, width, height)
        highlight.setPen(QPen(QColor(0, 255, 0, 150), 2, Qt.DashLine))
        highlight.setBrush(QBrush(QColor(0, 255, 0, 30)))
        highlight.setZValue(0.5)  # Below gates but above grid
        
        # Add to scene
        self.addItem(highlight)
        self.highlight_items.append(highlight)
        self.current_highlight = (row, col)
        
    def clear_highlights(self):
        """Remove any cell highlighting."""
        for item in self.highlight_items:
            self.removeItem(item)
        self.highlight_items.clear()
        self.current_highlight = None

    def dropEvent(self, event):
        """Handle a drop event to place, move, or remove a quantum gate."""
        # Clear any highlights first
        self.clear_highlights()
        pos = event.scenePos()
        x = pos.x() - self.left_margin
        y = pos.y()
        
                # Process the drop - position calculations
        col = int(x // self.grid_size)
        row = int(y // self.grid_size)
        
        # Check if the drop is within the circuit grid
        valid_drop_location = (0 <= col < self.num_layers and 
                              0 <= row < self.num_qubits and 
                              pos.x() >= self.left_margin)
        
        # If we're dragging an existing gate
        if self.drag_in_progress:
            # If dropped in trash zone, delete it
            if self.trash_zone_visible:
                # Gate is being dropped in the trash zone, delete it
                original_row, original_col = self.drag_source
                control_row = None
                
                # Check if this is part of a CNOT gate
                if original_col in self.cnot_layers:
                    # Find the other qubit in this CNOT
                    for (r, c), items in self.gate_positions.items():
                        if c == original_col and r != original_row:
                            control_row = r
                            break
                
                # Remove the gate from the circuit
                self.remove_gate(original_row, original_col)
                
                # Emit signal that gate was removed
                if control_row is not None:
                    # CNOT gate removal
                    self.gate_removed.emit(original_row, control_row, original_col)
                else:
                    # Single qubit gate removal
                    self.gate_removed.emit(original_row, -1, original_col)
                
                # Notify user of the deletion with informational message
                gate_type = "CNOT" if control_row is not None else "gate"
                #self.message_emitted.emit(f"{gate_type} successfully removed.")
            
            # If dropped in a valid grid location, move the gate
            elif valid_drop_location:
                original_row, original_col = self.drag_source
                gate_type = self._get_gate_type(original_row, original_col)
                
                # Skip if trying to move to the same location
                if original_row == row and original_col == col:
                    self.message_emitted.emit("Gate position unchanged.")
                    self.drag_in_progress = False
                    self.drag_source = None
                    self.hide_trash_zone()
                    return
                
                # Handle CNOT gates specially
                if gate_type == "CNOT":
                    # CNOT gates require special handling for movement - we need to:
                    # 1. Find the control and target qubits
                    # 2. Calculate the offset to maintain their relative positions
                    # 3. Check if the new position is valid
                    
                    # Find the other qubit in this CNOT
                    other_row = None
                    for (r, c), items in self.gate_positions.items():
                        if c == original_col and r != original_row:
                            other_row = r
                            break
                    
                    if other_row is not None:
                        # Calculate the row offset
                        offset = other_row - original_row
                        new_other_row = row + offset
                        
                        # Check if the new position is valid
                        if 0 <= new_other_row < self.num_qubits:
                            # Check if target column already has gates
                            if col in self.cnot_layers:
                                self.error_occurred.emit("Target column already has a CNOT gate!")
                            elif any(key[1] == col for key in self.gate_positions 
                                    if key[0] != original_row and key[0] != other_row):
                                self.error_occurred.emit("Target column has existing gates!")
                            else:
                                # Remove old CNOT
                                self.remove_gate(original_row, original_col)
                                self.gate_removed.emit(original_row, other_row, original_col)
                                
                                # Place new CNOT at new position
                                control_row = row if original_row < other_row else new_other_row
                                target_row = new_other_row if original_row < other_row else row
                                self.place_cnot(col, control_row, target_row)
                                self.gate_placed.emit(control_row, target_row, col, "CNOT")
                                self.message_emitted.emit("CNOT gate moved.")
                        else:
                            self.error_occurred.emit("Cannot move CNOT gate - would place outside circuit!")
                else:
                    # For single-qubit gates
                    
                    # Check if target position is valid
                    if col in self.cnot_layers:
                        self.error_occurred.emit("Cannot move gate to a column with CNOT!")
                    elif (row, col) in self.gate_positions:
                        self.error_occurred.emit("Position already has a gate!")
                    else:
                        # Remove the old gate
                        self.remove_gate(original_row, original_col)
                        self.gate_removed.emit(original_row, -1, original_col)
                        
                        # Place the gate at the new position
                        self.place_gate(col, row, gate_type)
                        self.gate_placed.emit(row, -1, col, gate_type)
                        self.message_emitted.emit(f"{gate_type} gate moved.")
            
            # Reset drag state
            self.drag_in_progress = False
            self.drag_source = None
            self.hide_trash_zone()
            
        # If we're placing a new gate from the palette
        else:
            # Only process if drop location is valid
            if valid_drop_location:
                gate_type = event.mimeData().text()
                
                if gate_type == "CNOT":
                    # Handle CNOT gate placement
                    if col in self.cnot_layers:
                        self.error_occurred.emit("Layer already contains a CNOT gate!")
                        return
                    if any(key[1] == col for key in self.gate_positions):
                        self.error_occurred.emit("Layer has existing gates! Remove them first.")
                        return
                    if self.pending_cnot is None:
                        # First click: register control qubit
                        self.pending_cnot = (col, row)
                        self.show_temp_control(col, row)
                    else:
                        # Second click: register target qubit if valid
                        prev_col, control_row = self.pending_cnot
                        target_row = row
                        if col == prev_col and control_row != target_row:
                            self.place_cnot(prev_col, control_row, target_row)
                            self.pending_cnot = None
                            self.cnot_layers.add(col)
                    return
                elif gate_type == "Custom":
                    # Request a custom gate
                    if col in self.cnot_layers:
                        self.error_occurred.emit("Cannot add custom gate to CNOT layer!")
                        return
                    self.custom_gate_requested.emit(row, col)
                    return
                
                # Single-qubit gates
                if col in self.cnot_layers:
                    self.error_occurred.emit("Cannot add gates to a layer with CNOT!")
                    return
                
                # Check if there's already a gate at this position
                if (row, col) in self.gate_positions:
                    self.error_occurred.emit("Position already has a gate!")
                    return
                
                self.place_gate(col, row, gate_type)
                self.gate_placed.emit(row, -1, col, gate_type)
            
            # Cleanup
            self.hide_trash_zone()
            self.drag_in_progress = False
            self.drag_source = None

    def mousePressEvent(self, event):
        """Handle mouse press events for CNOT gate completion or gate dragging."""
        if self.pending_cnot and event.button() == Qt.LeftButton:
            pos = event.scenePos()
            x = pos.x() - self.left_margin
            y = pos.y()
            col = int(x // self.grid_size)
            row = int(y // self.grid_size)
            if (0 <= col < self.num_layers and 
                0 <= row < self.num_qubits and 
                pos.x() >= self.left_margin):
                prev_col, control_row = self.pending_cnot
                if col == prev_col and row != control_row:
                    self.place_cnot(prev_col, control_row, row)
                    self.cnot_layers.add(col)
                    self.pending_cnot = None
                else:
                    self.pending_cnot = None
                    self.clear_temp_items()
        else:
            # Check if clicking on an existing gate to drag it
            pos = event.scenePos()
            x = pos.x() - self.left_margin
            y = pos.y()
            col = int(x // self.grid_size)
            row = int(y // self.grid_size)
            
            if (0 <= col < self.num_layers and 
                0 <= row < self.num_qubits and 
                pos.x() >= self.left_margin and
                (row, col) in self.gate_positions):
                
                # Start drag operation for an existing gate
                self.drag_in_progress = True
                self.drag_source = (row, col)
                
                # Get the gate type
                gate_type = self._get_gate_type(row, col)
                
                # Create drag object
                # Make sure views() is not empty before accessing
                if not self.views():
                    self.error_occurred.emit("No view available for drag operation")
                    self.drag_in_progress = False
                    self.drag_source = None
                    return
                    
                drag = QDrag(self.views()[0])
                mime = QMimeData()
                mime.setText(gate_type)
                drag.setMimeData(mime)
                
                # Create a pixmap for the drag
                x_center = self.left_margin + col * self.grid_size + self.grid_size // 2
                y_center = row * self.grid_size + self.grid_size // 2
                
                if gate_type == "CNOT":
                    # For CNOT, create a larger drag icon
                    pixmap = QPixmap(80, 80)
                    pixmap.fill(Qt.transparent)
                    painter = QPainter(pixmap)
                    painter.setPen(QPen(QColor(COLORS["gate"]["CNOT"]), 2))
                    painter.setBrush(QBrush(QColor(COLORS["gate"]["CNOT"])))
                    painter.drawEllipse(30, 30, 20, 20)  # Control dot
                    painter.drawEllipse(30, 30, 20, 20)  # Target circle
                    painter.end()
                else:
                    # For other gates, create a rectangle with text
                    pixmap = QPixmap(70, 30)
                    pixmap.fill(QColor(COLORS["gate"].get(gate_type, COLORS['primary'])))
                    painter = QPainter(pixmap)
                    painter.setPen(QPen(QColor('black')))
                    painter.setFont(QFont("Roboto", 14, QFont.Bold))
                    painter.drawText(pixmap.rect(), Qt.AlignCenter, gate_type)
                    painter.end()
                
                # Make the pixmap semi-transparent
                temp_pixmap = QPixmap(pixmap.size())
                temp_pixmap.fill(Qt.transparent)
                temp_painter = QPainter(temp_pixmap)
                temp_painter.setOpacity(0.7)
                temp_painter.drawPixmap(0, 0, pixmap)
                temp_painter.end()
                
                drag.setPixmap(temp_pixmap)
                drag.setHotSpot(QPoint(pixmap.width() // 2, pixmap.height() // 2))
                
                # Execute the drag
                result = drag.exec_(Qt.MoveAction)
                
                # If drag was not completed successfully, reset state
                if result == Qt.IgnoreAction:
                    self.drag_in_progress = False
                    self.drag_source = None
                    self.hide_trash_zone()
                
                # Prevent default handling
                return
                
        super().mousePressEvent(event)

    def _get_gate_type(self, row, col):
        """Determine the gate type at a given position."""
        if col in self.cnot_layers:
            return "CNOT"
        
        # For standard gates, check the text item
        items = self.gate_positions.get((row, col), [])
        if len(items) >= 2 and isinstance(items[1], QGraphicsTextItem):
            return items[1].toPlainText()
        
        return "Unknown"
    
    def show_temp_control(self, col, row):
        """Display a temporary indicator for a pending CNOT control qubit."""
        self.clear_temp_items()
        x = self.left_margin + col * self.grid_size + self.grid_size // 2 - 10
        y = row * self.grid_size + self.grid_size // 2 - 10
        
        # Control point
        control = QGraphicsEllipseItem(x, y, 20, 20)
        control.setBrush(QColor(COLORS["gate"]["CNOT"]))
        control.setPen(QPen(Qt.NoPen))
        control.setZValue(1)
        
        # Tooltip background
        tooltip_bg = QGraphicsRectItem(self.left_margin, -40, 300, 30)
        tooltip_bg.setBrush(QColor(COLORS['surface']))
        tooltip_bg.setPen(QPen(QColor('#555555'), 1))
        
        # Tooltip text
        tooltip_text = QGraphicsTextItem("Click target qubit in same column")
        tooltip_text.setDefaultTextColor(QColor('#FFFFFF'))
        tooltip_text.setFont(QFont("Roboto", 12))
        tooltip_text.setPos(self.left_margin + 10, -35)
        
        # Add items to scene
        self.addItem(control)
        self.addItem(tooltip_bg)
        self.addItem(tooltip_text)
        
        # Save for later removal
        self.temp_items = [control, tooltip_bg, tooltip_text]
    
    def clear_temp_items(self):
        """Remove temporary visual indicators."""
        for item in self.temp_items:
            self.removeItem(item)
        self.temp_items = []
    
    def place_cnot(self, col, control_row, target_row):
        """Place and visualize a CNOT gate."""
        # Clear existing gates in this layer
        for key in list(self.gate_positions.keys()):
            if key[1] == col:
                self.remove_gate(*key)
        
        # Control qubit (filled circle)
        control_x = self.left_margin + col * self.grid_size + self.grid_size // 2 - 10
        control_y = control_row * self.grid_size + self.grid_size // 2 - 10
        control = QGraphicsEllipseItem(control_x, control_y, 20, 20)
        control.setBrush(QColor(COLORS["gate"]["CNOT"]))
        control.setPen(QPen(Qt.NoPen))
        control.setZValue(1)
        
        # Target qubit (circle with X)
        target_x = self.left_margin + col * self.grid_size + self.grid_size // 2 - 15
        target_y = target_row * self.grid_size + self.grid_size // 2 - 15
        
        # Circle for target
        target_circle = QGraphicsEllipseItem(target_x, target_y, 30, 30)
        target_circle.setPen(QPen(QColor('#FFFFFF'), 2))
        target_circle.setBrush(QBrush(Qt.NoBrush))
        
        # X inside circle
        x_line1 = QGraphicsLineItem(target_x + 5, target_y + 5, target_x + 25, target_y + 25)
        x_line1.setPen(QPen(QColor('#FFFFFF'), 2))
        x_line2 = QGraphicsLineItem(target_x + 5, target_y + 25, target_x + 25, target_y + 5)
        x_line2.setPen(QPen(QColor('#FFFFFF'), 2))
        
        # Connecting line
        line = QGraphicsLineItem(
            control_x + 10, control_y + 10,
            target_x + 15, target_y + 15
        )
        line.setPen(QPen(QColor(COLORS["gate"]["CNOT"]), 2))
        
        # Add items to scene
        self.addItem(control)
        self.addItem(target_circle)
        self.addItem(x_line1)
        self.addItem(x_line2)
        self.addItem(line)
        
        # Save gate items
        self.gate_positions[(control_row, col)] = (control, target_circle, x_line1, x_line2, line)
        self.gate_positions[(target_row, col)] = (control, target_circle, x_line1, x_line2, line)
        self.cnot_layers.add(col)
        self.gate_placed.emit(control_row, target_row, col, "CNOT")
        self.clear_temp_items() 

    def remove_gate(self, row, col):
        """Remove a gate from the grid."""
        items = self.gate_positions.pop((row, col), [])
        
        # Also remove the other qubit of CNOT if applicable
        if col in self.cnot_layers:
            for key in list(self.gate_positions.keys()):
                if key[1] == col:
                    self.gate_positions.pop(key)
            self.cnot_layers.remove(col)
        
        # Remove items from scene
        for item in items:
            self.removeItem(item)
    
    def place_gate(self, col, row, gate_type):
        """Place and visualize a single-qubit gate."""
        if (row, col) in self.gate_positions:
            self.remove_gate(row, col)
            
        x = self.left_margin + col * self.grid_size + self.grid_size // 2 - 35
        y = row * self.grid_size + self.grid_size // 2 - 15
        
        # Gate rectangle
        rect = QGraphicsRectItem(x, y, 70, 30)
        rect.setBrush(QColor(COLORS["gate"].get(gate_type, COLORS['primary'])))
        rect.setPen(QPen(Qt.NoPen))
        rect.setZValue(1)
        
        # Gate label
        text = QGraphicsTextItem(gate_type)
        text.setDefaultTextColor(QColor('black'))
        text.setFont(QFont("Roboto", 14, QFont.Bold))
        text.setZValue(2)
        
        # Center text
        text_width = text.boundingRect().width()
        text_height = text.boundingRect().height()
        text.setPos(x + (70 - text_width) / 2, y + (30 - text_height) / 2)
        
        self.addItem(rect)
        self.addItem(text)
        self.gate_positions[(row, col)] = (rect, text)

# ------------------------------------------------------------------------------
# MainWindow: The primary window for the circuit designer
# ------------------------------------------------------------------------------
class MainWindow(QMainWindow):
    def __init__(self, num_qubits=4, num_layers=5):
        super().__init__()
        self.num_qubits = num_qubits
        self.num_layers = num_layers
        self.circuit = {}  # Dictionary for circuit configuration
        
        # Set application palette for dark theme with new colors
        QApplication.setPalette(self.create_dark_palette())
        
        # Try to load fonts
        self.load_fonts()
        self.initUI()

    def _create_circuit_controls(self):
        """Create horizontal controls for adjusting circuit dimensions."""
        # Create container widget for the controls
        container = QWidget()
        container.setStyleSheet(f"""
            QWidget {{
                background-color: {COLORS['toolbar']};
                border-bottom: 1px solid #e0e0e0;
                padding: 8px;
            }}
        """)

        # Create a horizontal layout
        control_layout = QHBoxLayout(container)
        control_layout.setContentsMargins(10, 5, 10, 5)
        control_layout.setSpacing(20)
        
        # Create a group for circuit dimensions
        dimensions_group = QGroupBox("Circuit Dimensions")
        dimensions_group.setStyleSheet(f"""
            QGroupBox {{
                background-color: {COLORS['toolbar']};
                border: 1px solid #e0e0e0;
                border-radius: 6px;
                margin-top: 12px;
                font-weight: bold;
                color: {COLORS['on_background']};
            }}
        """)
        dimensions_layout = QHBoxLayout(dimensions_group)
        dimensions_layout.setSpacing(15)
        
        # Create spin boxes for qubits and layers with improved styling
        qubit_label = QLabel("Number of Qubits:")
        qubit_label.setStyleSheet(f"color: {COLORS['on_background']}; font-weight: bold;")
        self.qubit_spin = QSpinBox()
        self.qubit_spin.setRange(1, 10)
        self.qubit_spin.setValue(self.num_qubits)
        self.qubit_spin.setFixedWidth(80)
        self.qubit_spin.setStyleSheet(f"""
            QSpinBox {{
                background-color: {COLORS['background']};
                border: 1px solid #bdc3c7;
                border-radius: 4px;
                padding: 5px;
                color: {COLORS['toolbar']};
            }}
            QSpinBox::up-button, QSpinBox::down-button {{
                border: none;
                background-color: {COLORS['primary']};
                color: white;
                border-radius: 2px;
            }}
            QSpinBox::up-button:hover, QSpinBox::down-button:hover {{
                background-color: {COLORS['button']['hover']};
            }}
        """)
        
        layer_label = QLabel("Number of Layers:")
        layer_label.setStyleSheet(f"color: {COLORS['on_background']}; font-weight: bold;")
        self.layer_spin = QSpinBox()
        self.layer_spin.setRange(1, 20)
        self.layer_spin.setValue(self.num_layers)
        self.layer_spin.setFixedWidth(80)
        self.layer_spin.setStyleSheet(self.qubit_spin.styleSheet())
        
        # Add dimension controls to their layout
        dimensions_layout.addWidget(qubit_label)
        dimensions_layout.addWidget(self.qubit_spin)
        dimensions_layout.addWidget(layer_label)
        dimensions_layout.addWidget(self.layer_spin)
        
        # Create Apply button with improved styling
        apply_button = QPushButton("Apply Changes")
        apply_button.setCursor(Qt.PointingHandCursor)
        apply_button.setFixedWidth(140)
        apply_button.setStyleSheet(f"""
            QPushButton {{
                background-color: {COLORS['button']['normal']};
                color: {COLORS['background']};
                border-radius: 6px;
                border: none;
                padding: 8px 16px;
                font-family: 'Roboto', sans-serif;
                font-weight: 600;
                font-size: 14px;
            }}
            QPushButton:hover {{
                background-color: {COLORS['button']['hover']};
            }}
            QPushButton:pressed {{
                background-color: {COLORS['button']['active']};
            }}
        """)
        
        # Add drop shadow effect to button
        shadow = QGraphicsDropShadowEffect()
        shadow.setBlurRadius(10)
        shadow.setColor(QColor(0, 0, 0, 100))
        shadow.setOffset(0, 3)
        apply_button.setGraphicsEffect(shadow)
        
        apply_button.clicked.connect(self.apply_circuit_dimensions)
        
        # Create QSPresso logo with coffee styling
        qspice_label = QLabel("QPU")
        qspice_label.setStyleSheet(f"""
            color: {COLORS['background']};
            font-family: 'Palatino', 'Times New Roman', serif;
            font-weight: 800;
            font-size: 32px;
            letter-spacing: 3px;
            padding: 10px;
        """)
        
        # Add enhanced glow and shadow effect to QSPresso text
        qspice_shadow = QGraphicsDropShadowEffect()
        qspice_shadow.setBlurRadius(20)
        qspice_shadow.setColor(QColor(COLORS['primary']))
        qspice_shadow.setOffset(2, 2)
        qspice_label.setGraphicsEffect(qspice_shadow)
        
        # Add all elements to the main layout
        control_layout.addWidget(dimensions_group)
        control_layout.addWidget(apply_button)
        control_layout.addStretch()
        control_layout.addWidget(qspice_label)
        
        # Store container for later use
        self.control_container = container

    def load_superdense_circuit(self):
        """Load a predefined Superdense Coding circuit"""
        self.clear_circuit()

        if self.num_qubits < 2:
            self.show_error_message("Superdense coding requires ≥2 qubits!")
            return
        if self.num_layers < 5:
            self.show_error_message("Superdense coding requires ≥3 layers!")
            return

        try:
            # Example superdense coding circuit
            # Layer 0: Entanglement creation
            self.scene.place_gate(0, 0, "H")
            self.scene.place_cnot(1, 0, 1)

            # Layer 1: Alice's operations
            #self.scene.place_gate(2, 0, "Z")
            self.scene.place_gate(2, 0, "X")

            # Layer 2: Bob's decoding
            self.scene.place_cnot(3, 0, 1)
            self.scene.place_gate(4, 0, "H")

            self.statusBar().showMessage("Loaded Superdense Coding circuit!", 3000)
        except Exception as e:
            self.show_error_message(f"Error: {str(e)}")

    def load_bell_circuit(self):
        """Load a predefined Bell state circuit (H on q0, CNOT q0->q1)."""
        self.clear_circuit()
        
        # Check circuit dimensions
        if self.num_qubits < 2:
            self.show_error_message("Bell circuit requires ≥2 qubits!")
            return
        if self.num_layers < 2:
            self.show_error_message("Bell circuit requires ≥2 layers!")
            return

        try:
            # Place H gate on qubit 0, layer 0
            self.scene.place_gate(0, 0, "H")
            self.scene.gate_placed.emit(0, -1, 0, "H")  # Emit signal

            # Place CNOT on layer 1 (control q0, target q1)
            self.scene.place_cnot(1, 0, 1)
            
            self.statusBar().showMessage("Loaded Bell state circuit!", 3000)
        except Exception as e:
            self.show_error_message(f"Error: {str(e)}")

    ##########
    def _create_prebuilt_circuits_panel(self):
        """Create the prebuilt circuits section in the toolbar."""
        prebuilt_group = QGroupBox("Prebuilt Circuits")
        prebuilt_group.setStyleSheet(f"""
            QGroupBox {{
                background-color: {COLORS['background']};
                border: 2px solid {COLORS['surface']};
                border-radius: 8px;
                margin-top: 12px;
                font-weight: bold;
                color: {COLORS['on_background']};
                padding: 10px;
            }}
        """)

        prebuilt_layout = QVBoxLayout(prebuilt_group)
        prebuilt_layout.setSpacing(10)

        # Create Bell Circuit button with matching style
        bell_btn = QPushButton("Load Bell Circuit")
        bell_btn.setStyleSheet(f"""
            QPushButton {{
                background-color: {COLORS['secondary']};
                color: {COLORS['on_secondary']};
                border-radius: 6px;
                border: 1px solid {COLORS['surface']};
                padding: 8px;
                font-family: 'Palatino', 'Times New Roman', serif;
                font-weight: 600;
                font-size: 14px;
            }}
            QPushButton:hover {{
                background-color: {COLORS['button']['hover']};
            }}
            QPushButton:pressed {{
                background-color: {COLORS['button']['active']};
            }}
        """)
        bell_btn.clicked.connect(self.load_bell_circuit)

        prebuilt_layout.addWidget(bell_btn)
        prebuilt_layout.addStretch()

        return prebuilt_group
    ###########
        
    def apply_circuit_dimensions(self):
        """Apply new circuit dimensions and rebuild the circuit."""
        new_qubits = self.qubit_spin.value()
        new_layers = self.layer_spin.value()

        # Only rebuild if dimensions have changed
        if new_qubits != self.num_qubits or new_layers != self.num_layers:
            self.num_qubits = new_qubits
            self.num_layers = new_layers

            # Clear current circuit
            self.circuit = {}

            # Rebuild the circuit scene
            if hasattr(self, 'view'):
                self.view.setParent(None)  # Remove old view

            # Create new scene and view
            self._create_main_view()

            self.statusBar().showMessage(f"Circuit resized to {new_qubits} qubits and {new_layers} layers", 3000)
        
    def create_dark_palette(self):
        """Create a dark palette for the application with updated colors"""
        dark_palette = QPalette()
        dark_palette.setColor(QPalette.Window, QColor(COLORS['background']))
        dark_palette.setColor(QPalette.WindowText, QColor(COLORS['on_background']))
        dark_palette.setColor(QPalette.Base, QColor(COLORS['surface']))
        dark_palette.setColor(QPalette.AlternateBase, QColor(COLORS['background']))
        dark_palette.setColor(QPalette.ToolTipBase, QColor(COLORS['surface']))
        dark_palette.setColor(QPalette.ToolTipText, QColor(COLORS['on_surface']))
        dark_palette.setColor(QPalette.Text, QColor(COLORS['on_surface']))
        dark_palette.setColor(QPalette.Button, QColor(COLORS['surface']))
        dark_palette.setColor(QPalette.ButtonText, QColor(COLORS['on_surface']))
        dark_palette.setColor(QPalette.Link, QColor(COLORS['primary']))
        dark_palette.setColor(QPalette.Highlight, QColor(COLORS['primary']))
        dark_palette.setColor(QPalette.HighlightedText, QColor('black'))
        
        # Disabled state colors
        dark_palette.setColor(QPalette.Disabled, QPalette.ButtonText, QColor('#666666'))
        dark_palette.setColor(QPalette.Disabled, QPalette.WindowText, QColor('#666666'))
        dark_palette.setColor(QPalette.Disabled, QPalette.Text, QColor('#666666'))
        
        return dark_palette
    
    def load_fonts(self):
        """Try to load aesthetic fonts for the application"""
        fontDb = QFontDatabase()
        font_families = fontDb.families()
        
        # Set default font to a more aesthetic serif font
        default_font = QFont("Palatino", 14)
        if "Palatino" not in font_families:
            # Fallback to other aesthetic fonts
            if "Georgia" in font_families:
                default_font = QFont("Georgia", 14)
            elif "Times New Roman" in font_families:
                default_font = QFont("Times New Roman", 14)
            else:
                default_font = QFont("serif", 14)
        
        QApplication.setFont(default_font)
        
    def initUI(self):
        """Set up the main window, toolbar, and circuit view."""
        self.setWindowTitle('QPU')  # Coffee-themed name
        self.setGeometry(100, 100, 1000, 700)
        self.setObjectName("mainWindow")
        
        # Apply dark theme styling with enhanced aesthetics
        self.setStyleSheet(f"""
            #mainWindow {{
                background-color: {COLORS['background']};
                border: 1px solid #333333;
            }}
            QMainWindow::title {{
                background-color: {COLORS['surface']};
                color: {COLORS['on_surface']};
                font-family: 'Palatino', 'Times New Roman', serif;
            }}
            QStatusBar {{
                background-color: {COLORS['surface']};
                color: {COLORS['on_surface']};
                font-family: 'Palatino', 'Times New Roman', serif;
                padding: 8px;
                border-top: 1px solid #333333;
            }}
            /* Dark theme scrollbar styling with enhanced aesthetics */
            QScrollBar:vertical {{
                border: none;
                background: {COLORS['surface']};
                width: 10px;
                margin: 0px;
                border-radius: 5px;
            }}
            QScrollBar::handle:vertical {{
                background: #555555;
                min-height: 20px;
                border-radius: 5px;
            }}
            QScrollBar::add-line:vertical, QScrollBar::sub-line:vertical {{
                height: 0px;
            }}
            QScrollBar:horizontal {{
                border: none;
                background: {COLORS['surface']};
                height: 10px;
                margin: 0px;
                border-radius: 5px;
            }}
            QScrollBar::handle:horizontal {{
                background: #555555;
                min-width: 20px;
                border-radius: 5px;
            }}
            QScrollBar::add-line:horizontal, QScrollBar::sub-line:horizontal {{
                width: 0px;
            }}
            /* Menu styling with improved typography */
            QMenuBar {{
                background-color: {COLORS['surface']};
                color: {COLORS['on_surface']};
                font-family: 'Palatino', 'Times New Roman', serif;
            }}
            QMenuBar::item {{
                background: transparent;
            }}
            QMenuBar::item:selected {{
                background: #333333;
            }}
            QMenu {{
                background-color: {COLORS['surface']};
                color: {COLORS['on_surface']};
                border: 1px solid #333333;
                border-radius: 4px;
                font-family: 'Palatino', 'Times New Roman', serif;
            }}
            QMenu::item:selected {{
                background: #333333;
            }}
            /* Group box styling with 3D shadows */
            QGroupBox {{
                background-color: {COLORS['surface']};
                color: {COLORS['on_surface']};
                border: 1px solid #333333;
                border-radius: 6px;
                margin-top: 16px;
                font-weight: bold;
                font-family: 'Palatino', 'Times New Roman', serif;
            }}
            QGroupBox::title {{
                subcontrol-origin: margin;
                subcontrol-position: top center;
                padding: 0 5px;
            }}
            /* SpinBox with 3D appearance */
            QSpinBox {{
                background-color: #2D2D2D;
                color: {COLORS['on_surface']};
                border: 1px solid rgba(255, 255, 255, 0.1);
                border-bottom: 2px solid rgba(0, 0, 0, 0.3);
                border-radius: 4px;
                padding: 5px;
                font-family: 'Palatino', 'Times New Roman', serif;
            }}
            QSpinBox::up-button, QSpinBox::down-button {{
                border: none;
                width: 16px;
                border-left: 1px solid #555555;
                background-color: rgba(255, 255, 255, 0.05);
            }}
            QSpinBox::up-button:hover, QSpinBox::down-button:hover {{
                background-color: rgba(255, 255, 255, 0.1);
            }}
            QSpinBox::up-button:pressed, QSpinBox::down-button:pressed {{
                background-color: rgba(0, 0, 0, 0.1);
            }}
        """)
        
        # Create toolbar and main view
        self._create_toolbar()
        self._create_circuit_controls()
        self._create_main_view()
        self.statusBar().showMessage("Ready")
    
    def _create_toolbar(self):
        """Create the toolbar with gate widgets and control buttons."""
        toolbar = QToolBar("Gates")
        toolbar.setMovable(False)
        toolbar.setFloatable(False)
        toolbar.setStyleSheet(f"""
            QToolBar {{
                background-color: {COLORS['toolbar']};
                spacing: 12px;
                padding: 12px;
                border: none;
                border-right: 1px solid #e0e0e0;
            }}
            QToolButton {{ 
                margin: 4px;
            }}
        """)

        # Create sections for different types of gates
        single_qubit_group = QGroupBox("Single Qubit Gates")
        single_qubit_group.setStyleSheet(f"""
            QGroupBox {{
                background-color: {COLORS['toolbar']};
                border: 1px solid #e0e0e0;
                border-radius: 6px;
                margin-top: 12px;
                font-weight: bold;
                color: {COLORS['on_background']};
            }}
        """)
        single_qubit_layout = QGridLayout(single_qubit_group)
        single_qubit_layout.setSpacing(8)

        two_qubit_group = QGroupBox("Two Qubit Gates")
        two_qubit_group.setStyleSheet(f"""
            QGroupBox {{
                background-color: {COLORS['toolbar']};
                border: 1px solid #e0e0e0;
                border-radius: 6px;
                margin-top: 12px;
                font-weight: bold;
                color: {COLORS['on_background']};
            }}
        """)
        two_qubit_layout = QGridLayout(two_qubit_group)
        two_qubit_layout.setSpacing(8)

        # Add gates to appropriate sections
        single_qubit_gates = ['H', 'X', 'Y', 'Z']
        two_qubit_gates = ['CNOT', 'Custom']

        for i, gate in enumerate(single_qubit_gates):
            btn = self._create_gate_button(gate)
            btn.setToolTip(f"{gate} Gate\nDrag to circuit to place")
            single_qubit_layout.addWidget(btn, i//2, i%2)

        for i, gate in enumerate(two_qubit_gates):
            btn = self._create_gate_button(gate)
            btn.setToolTip(f"{gate} Gate\nDrag to circuit to place" + 
                          ("\n(Click control then target qubit)" if gate == "CNOT" else ""))
            two_qubit_layout.addWidget(btn, i, 0)

        # Add prebuilt circuits section
        prebuilt_group = QGroupBox("Prebuilt Circuits")
        prebuilt_group.setStyleSheet(f"""
            QGroupBox {{
                background-color: {COLORS['toolbar']};
                border: 1px solid #e0e0e0;
                border-radius: 6px;
                margin-top: 12px;
                font-weight: bold;
                color: {COLORS['on_background']};
            }}
        """)
        prebuilt_layout = QGridLayout(prebuilt_group)
        prebuilt_layout.setSpacing(8)

        # Create Bell Circuit button with matching style
        bell_btn = QPushButton()
        bell_btn.setFixedSize(90, 45)
        bell_btn.setStyleSheet(f"""
            QPushButton {{
                background-color: {COLORS['secondary']};
                color: {COLORS['on_secondary']};
                border-radius: 8px;
                border: 1px solid {COLORS['surface']};
                border-bottom: 3px solid {COLORS['surface']};
                font-family: 'Palatino', 'Times New Roman', serif;
                font-weight: 700;
                font-size: 18px;
                text-transform: uppercase;
                letter-spacing: 1px;
            }}
            QPushButton:hover {{
                background-color: {COLORS['button']['hover']};
                border-bottom: 2px solid {COLORS['surface']};
                margin-top: 1px;
            }}
            QPushButton:pressed {{
                background-color: {COLORS['button']['active']};
                border-bottom: 1px solid {COLORS['surface']};
                margin-top: 2px;
            }}
        """)
        bell_btn.setText("Bell")
        bell_btn.setCursor(Qt.PointingHandCursor)

        # Create Superdense Coding button
        superdense_btn = QPushButton()
        superdense_btn.setFixedSize(90, 45)
        superdense_btn.setStyleSheet(f"""
            QPushButton {{
                background-color: {COLORS['secondary']};
                color: {COLORS['on_secondary']};
                border-radius: 8px;
                border: 1px solid {COLORS['surface']};
                border-bottom: 3px solid {COLORS['surface']};
                font-family: 'Palatino', 'Times New Roman', serif;
                font-weight: 700;
                font-size: 18px;
                text-transform: uppercase;
                letter-spacing: 1px;
            }}
            QPushButton:hover {{
                background-color: {COLORS['button']['hover']};
                border-bottom: 2px solid {COLORS['surface']};
                margin-top: 1px;
            }}
            QPushButton:pressed {{
                background-color: {COLORS['button']['active']};
                border-bottom: 1px solid {COLORS['surface']};
                margin-top: 2px;
            }}
        """)
        superdense_btn.setText("Dense")
        superdense_btn.setCursor(Qt.PointingHandCursor)

        # Add shadow effects to both buttons
        for btn in [bell_btn, superdense_btn]:
            shadow = QGraphicsDropShadowEffect()
            shadow.setBlurRadius(8)
            shadow.setOffset(0, 3)
            shadow.setColor(QColor(COLORS['shadow']))
            btn.setGraphicsEffect(shadow)

        bell_btn.clicked.connect(self.load_bell_circuit)
        superdense_btn.clicked.connect(self.load_superdense_circuit)

        # Add buttons to layout with centering
        prebuilt_layout.addWidget(bell_btn, 0, 0, Qt.AlignHCenter)
        prebuilt_layout.addWidget(superdense_btn, 1, 0, Qt.AlignHCenter)
        prebuilt_layout.setRowStretch(2, 1)  # Maintain centering

        # Add all groups to toolbar
        toolbar.addWidget(single_qubit_group)
        toolbar.addWidget(two_qubit_group)
        toolbar.addWidget(prebuilt_group)

        # Add spacer
        spacer = QWidget()
        spacer.setSizePolicy(QSizePolicy.Preferred, QSizePolicy.Expanding)
        toolbar.addWidget(spacer)

        # Add control buttons
        self._add_control_buttons(toolbar)

        self.addToolBar(Qt.LeftToolBarArea, toolbar)

    def _create_gate_button(self, gate_type):
        """Create a 3D keyboard-like gate button with shadows"""
        btn = QLabel()
        btn.gate_type = gate_type
        btn.setFixedSize(90, 45)  # Slightly larger for better visibility
        btn.setAlignment(Qt.AlignCenter)
        
        # Coffee-themed style with improved visibility
        btn.setStyleSheet(f"""
            background-color: {COLORS['gate'].get(gate_type, COLORS['primary'])};
            color: {COLORS['on_primary']};
            border-radius: 8px;
            border: 1px solid {COLORS['surface']};
            border-bottom: 3px solid {COLORS['surface']};
            font-family: 'Palatino', 'Times New Roman', serif;
            font-weight: 700;
            font-size: 18px;
            text-transform: uppercase;
            letter-spacing: 1px;
        """)
        btn.setText(gate_type)
        btn.setCursor(Qt.OpenHandCursor)
        
        # Enhanced coffee-themed elevation
        shadow = QGraphicsDropShadowEffect()
        shadow.setBlurRadius(8)
        shadow.setOffset(0, 3)
        shadow.setColor(QColor(COLORS['shadow']))
        btn.setGraphicsEffect(shadow)
        
        # Handle mouse move for drag operations
        btn.mouseMoveEvent = lambda event: self._gate_mouse_move(event, btn)
        
        # Add hover effect
        def enterEvent(event):
            btn.setStyleSheet(btn.styleSheet().replace(
                f"background-color: {COLORS['gate'].get(gate_type, COLORS['primary'])}",
                f"background-color: {COLORS['button']['hover']}"
            ))
            
        def leaveEvent(event):
            btn.setStyleSheet(btn.styleSheet().replace(
                f"background-color: {COLORS['button']['hover']}",
                f"background-color: {COLORS['gate'].get(gate_type, COLORS['primary'])}"
            ))
            
        btn.enterEvent = enterEvent
        btn.leaveEvent = leaveEvent
        
        return btn
    
    def _gate_mouse_move(self, event, btn):
        """Handle mouse move event for gate drag operations"""
        if event.buttons() != Qt.LeftButton:
            return
        drag = QDrag(btn)
        mime = QMimeData()
        mime.setText(btn.gate_type)
        drag.setMimeData(mime)
        
        # Create a semi-transparent pixmap for drag feedback with enhanced 3D style
        pixmap = btn.grab().scaled(60, 30)
        painter = QPainter(pixmap)
        painter.setCompositionMode(QPainter.CompositionMode_DestinationIn)
        painter.fillRect(pixmap.rect(), QColor(255, 255, 255, 180))
        painter.end()
        
        drag.setPixmap(pixmap)
        drag.setHotSpot(event.pos())
        drag.exec_(Qt.CopyAction)
    
    def _add_control_buttons(self, toolbar):
        """Add simulation and clear buttons to toolbar with coffee-themed 3D styling."""
        # Coffee-themed button styles
        button_style = f"""
            QPushButton {{
                background-color: {COLORS['button']['normal']};
                color: {COLORS['on_primary']};
                border-radius: 8px;
                border: 1px solid {COLORS['surface']};
                border-bottom: 3px solid {COLORS['surface']};
                padding: 12px 20px;
                font-family: 'Palatino', 'Times New Roman', serif;
                font-weight: 600;
                font-size: 15px;
                text-transform: uppercase;
                letter-spacing: 1px;
            }}
            QPushButton:hover {{
                background-color: {COLORS['button']['hover']};
                border-bottom: 2px solid {COLORS['surface']};
                margin-top: 1px;
            }}
            QPushButton:pressed {{
                background-color: {COLORS['button']['active']};
                border-bottom: 1px solid {COLORS['surface']};
                margin-top: 2px;
            }}
        """
        
        clear_style = f"""
            QPushButton {{
                background-color: {COLORS['button']['clear']};
                color: {COLORS['on_error']};
                border-radius: 8px;
                border: 1px solid #8B0000;
                border-bottom: 3px solid #8B0000;
                padding: 12px 20px;
                font-family: 'Palatino', 'Times New Roman', serif;
                font-weight: 600;
                font-size: 15px;
                text-transform: uppercase;
                letter-spacing: 1px;
            }}
            QPushButton:hover {{
                background-color: #D63447;
                border-bottom: 2px solid #8B0000;
                margin-top: 1px;
            }}
            QPushButton:pressed {{
                background-color: #B22222;
                border-bottom: 1px solid #8B0000;
                margin-top: 2px;
            }}
        """
        
        # Simulation button with enhanced coffee-themed shadow
        simulate_btn = QPushButton("Run Circuit")  # Coffee-themed label
        simulate_btn.setStyleSheet(button_style)
        simulate_btn.setCursor(Qt.PointingHandCursor)
        
        # Add richer shadow effect
        sim_shadow = QGraphicsDropShadowEffect()
        sim_shadow.setBlurRadius(12)
        sim_shadow.setOffset(0, 4)
        sim_shadow.setColor(QColor(COLORS['shadow']))
        simulate_btn.setGraphicsEffect(sim_shadow)
        
        simulate_btn.clicked.connect(self.run_simulation)
        toolbar.addWidget(simulate_btn)
        
        # Add spacing
        spacer = QWidget()
        spacer.setFixedHeight(10)
        toolbar.addWidget(spacer)
        
        # Clear button with enhanced coffee-themed shadow
        clear_btn = QPushButton("Clear Circuit")  # Coffee-themed label
        clear_btn.setStyleSheet(clear_style)
        clear_btn.setCursor(Qt.PointingHandCursor)
        
        # Add richer shadow effect
        clear_shadow = QGraphicsDropShadowEffect()
        clear_shadow.setBlurRadius(12)
        clear_shadow.setOffset(0, 4)
        clear_shadow.setColor(QColor(COLORS['shadow']))
        clear_btn.setGraphicsEffect(clear_shadow)
        
        clear_btn.clicked.connect(self.clear_circuit)
        toolbar.addWidget(clear_btn)

    def _create_main_view(self):
        """Create the QGraphicsView for the circuit."""
        self.scene = CircuitScene(self.num_qubits, self.num_layers)
        self.view = QGraphicsView(self.scene)
        self.view.setRenderHints(QPainter.Antialiasing | QPainter.SmoothPixmapTransform)
        self.view.setAcceptDrops(True)
        self.view.setStyleSheet(f"""
            QGraphicsView {{
                border: 1px solid #e0e0e0;
                border-radius: 8px;
                background-color: {COLORS['background']};
                color: {COLORS['on_background']};
            }}
        """)
        
        # Connect signals
        self.scene.error_occurred.connect(self.show_error_message)
        self.scene.custom_gate_requested.connect(self.handle_custom_gate)
        self.scene.gate_placed.connect(self._update_circuit)
        
        # Add shadow effect to the view for subtle depth
        view_shadow = QGraphicsDropShadowEffect()
        view_shadow.setBlurRadius(20)
        view_shadow.setOffset(0, 0)
        view_shadow.setColor(QColor(0, 0, 0, 40))
        self.view.setGraphicsEffect(view_shadow)
        
        # Create a layout to hold the controls and view
        main_layout = QVBoxLayout()
        main_layout.setSpacing(10)
        main_layout.setContentsMargins(10, 10, 10, 10)
        main_layout.addWidget(self.control_container)
        main_layout.addWidget(self.view)
        
        # Create central widget to hold the layout
        central_widget = QWidget()
        central_widget.setLayout(main_layout)
        central_widget.setStyleSheet(f"""
            QWidget {{
                background-color: {COLORS['background']};
            }}
        """)
        self.setCentralWidget(central_widget)

    def clear_circuit(self):
        """Clear the current circuit configuration."""
        self.circuit = {}
        self.scene.clear()
        self.scene.init_grid()
        self.scene.gate_positions = {}
        self.scene.cnot_layers = set()
        self.scene.pending_cnot = None
        self.statusBar().showMessage("Circuit cleared", 3000)

    def handle_custom_gate(self, row, col):
        """Handle a request to place a custom gate."""
        matrix = self.get_custom_matrix()
        if matrix is not None:
            self.scene.place_gate(col, row, "Custom")
            key = (row, col)
            self.circuit[key] = {"type": "Custom", "matrix": matrix}
            self.statusBar().showMessage(f"Placed Custom gate on Qubit {row+1}, Layer {col+1}")
            print(f"Custom gate matrix:\n{matrix}")

    def get_custom_matrix(self):
        """Open a dialog to input a custom gate matrix with enhanced styling."""
        dialog = QDialog(self)
        dialog.setWindowTitle("Custom Gate Matrix")
        
        # Apply enhanced 3D styling to dialog
        dialog.setStyleSheet(f"""
            QDialog {{
                background-color: {COLORS['surface']};
            }}
            QLineEdit {{
                padding: 8px;
                border: 1px solid rgba(255, 255, 255, 0.1);
                border-bottom: 2px solid rgba(0, 0, 0, 0.2);
                border-radius: 4px;
                background-color: #2D2D2D;
                color: {COLORS['on_surface']};
                font-family: 'Palatino', 'Times New Roman', serif;
            }}
            QLineEdit:focus {{
                border: 2px solid {COLORS['primary']};
                border-bottom: 3px solid {COLORS['primary']};
            }}
            QDialogButtonBox {{
                button-layout: 2;
            }}
            QPushButton {{
                background-color: {COLORS['primary']};
                color: {COLORS['on_primary']};
                border: 1px solid rgba(255, 255, 255, 0.2);
                border-bottom: 2px solid rgba(0, 0, 0, 0.3);
                border-radius: 4px;
                padding: 8px 16px;
                font-family: 'Palatino', 'Times New Roman', serif;
                font-weight: 600;
                text-transform: uppercase;
            }}
            QPushButton:hover {{
                background-color: {COLORS['button']['hover']};
            }}
            QPushButton:pressed {{
                background-color: {COLORS['button']['active']};
                border-bottom: 1px solid rgba(0, 0, 0, 0.3);
                margin-top: 1px;
            }}
            QComboBox {{
                padding: 8px;
                border: 1px solid rgba(255, 255, 255, 0.1);
                border-bottom: 2px solid rgba(0, 0, 0, 0.2);
                border-radius: 4px;
                background-color: #2D2D2D;
                color: {COLORS['on_surface']};
                font-family: 'Palatino', 'Times New Roman', serif;
            }}
            QComboBox:hover {{
                border: 1px solid {COLORS['primary']};
            }}
            QLabel {{
                color: {COLORS['on_surface']};
                font-family: 'Palatino', 'Times New Roman', serif;
                font-weight: 500;
            }}
        """)
        
        # Main layout
        main_layout = QVBoxLayout()
        
        # Size selector
        size_layout = QHBoxLayout()
        size_label = QLabel("Matrix Size:")
        size_combo = QComboBox()
        
        # Add powers of 2 options (2x2, 4x4, 8x8, 16x16)
        for i in range(1, 5):
            size = 2 ** i
            size_combo.addItem(f"{size}x{size}", size)
        
        # Set default to 4x4
        size_combo.setCurrentIndex(1)
        
        # Add shadow effect to combo box
        combo_shadow = QGraphicsDropShadowEffect()
        combo_shadow.setBlurRadius(8)
        combo_shadow.setOffset(0, 2)
        combo_shadow.setColor(QColor(0, 0, 0, 80))
        size_combo.setGraphicsEffect(combo_shadow)
        
        size_layout.addWidget(size_label)
        size_layout.addWidget(size_combo)
        main_layout.addLayout(size_layout)
        
        # Create grid layout for matrix inputs
        grid_layout = QGridLayout()
        
        # Create a container widget for the grid layout
        grid_widget = QWidget()
        grid_widget.setLayout(grid_layout)
        
        # Add to main layout
        main_layout.addWidget(grid_widget)
        
        # Initial inputs for 4x4 matrix
        current_size = 4
        inputs = []
        
        # Function to update the matrix grid when size changes
        def update_matrix_grid(size):
            nonlocal inputs, grid_layout, grid_widget
            
            # Clear existing grid
            while grid_layout.count():
                item = grid_layout.takeAt(0)
                if item.widget():
                    item.widget().deleteLater()
            
            # Create new inputs with enhanced styling
            inputs = []
            for i in range(size):
                row_inputs = []
                for j in range(size):
                    edit = QLineEdit()
                    edit.setPlaceholderText(f"({i+1},{j+1})")
                    
                    # Add shadow effect to each input
                    edit_shadow = QGraphicsDropShadowEffect()
                    edit_shadow.setBlurRadius(5)
                    edit_shadow.setOffset(0, 1)
                    edit_shadow.setColor(QColor(0, 0, 0, 50))
                    edit.setGraphicsEffect(edit_shadow)
                    
                    grid_layout.addWidget(edit, i, j)
                    row_inputs.append(edit)
                inputs.append(row_inputs)
        
        # Connect the size selector to the update function
        size_combo.currentIndexChanged.connect(
            lambda idx: update_matrix_grid(size_combo.itemData(idx))
        )
        
        # Initialize with 4x4 grid
        update_matrix_grid(current_size)
        
        # Dialog buttons with 3D styling
        btn_box = QDialogButtonBox(QDialogButtonBox.Ok | QDialogButtonBox.Cancel)
        btn_box.accepted.connect(dialog.accept)
        btn_box.rejected.connect(dialog.reject)
        
        # Add shadow to buttons
        for button in btn_box.buttons():
            button_shadow = QGraphicsDropShadowEffect()
            button_shadow.setBlurRadius(8)
            button_shadow.setOffset(0, 2)
            button_shadow.setColor(QColor(0, 0, 0, 80))
            button.setGraphicsEffect(button_shadow)
        
        main_layout.addWidget(btn_box)
        
        dialog.setLayout(main_layout)
        
        # Get matrix from dialog
        if dialog.exec_() == QDialog.Accepted:
            current_size = size_combo.itemData(size_combo.currentIndex())
            matrix = []
            for i in range(current_size):
                matrix_row = []
                for j in range(current_size):
                    try:
                        val = complex(inputs[i][j].text())
                    except:
                        val = 0j
                    matrix_row.append(val)
                matrix.append(matrix_row)
            return matrix
        return None

    def _update_circuit(self, control_row, target_row, col, gate_type):
        """Update internal circuit configuration."""
        if gate_type == "CNOT":
            key = (col, "CNOT")
            self.circuit[key] = (control_row, target_row)
            msg = f"CNOT: Control Q{control_row+1}, Target Q{target_row+1} at Layer {col+1}"
        else:
            key = (control_row, col)
            self.circuit[key] = gate_type
            msg = f"Placed {gate_type} gate on Qubit {control_row+1}, Layer {col+1}"
        self.statusBar().showMessage(msg)
        print(msg)

    def show_error_message(self, message):
        """Display an error message in the status bar with enhanced styling."""
        self.statusBar().setStyleSheet(f"""
            QStatusBar {{
                background-color: {COLORS['error']};
                color: {COLORS['on_error']};
                font-family: 'Palatino', 'Times New Roman', serif;
                padding: 8px;
                border-top: 1px solid rgba(0, 0, 0, 0.2);
            }}
        """)
        self.statusBar().showMessage(message)
        QTimer.singleShot(3000, self.reset_status_style)
    
    def reset_status_style(self):
        """Reset the status bar style after showing an error."""
        self.statusBar().setStyleSheet(f"""
            QStatusBar {{
                background-color: {COLORS['surface']};
                color: {COLORS['on_surface']};
                font-family: 'Palatino', 'Times New Roman', serif;
                padding: 8px;
                border-top: 1px solid #333333;
            }}
        """)
        self.statusBar().clearMessage()

    def get_circuit_config(self):
        """Return the current circuit configuration."""
        return self.circuit
    
    def run_simulation(self):
        """Run the quantum circuit simulation."""
        try:
            # Build circuit layers
            layers = self.get_circuit_layers()
            # Filter out any empty layers
            non_empty_layers = [layer for layer in layers if layer]
            # Initialize the quantum circuit
            circuit = Circuit(non_empty_layers, total_qubits=self.num_qubits)
            # Apply each layer to evolve the quantum state
            for _ in range(len(non_empty_layers)):
                circuit.step(RUN_ON_HARDWARE=RUN_ON_HARDWARE)
            # Calculate final state probabilities
            probabilities = np.abs(circuit.state_vector)**2
            # Visualize results
            self.plot_probabilities(probabilities, circuit.state_evolution)
        except Exception as e:
            self.show_error_message(f"Simulation error: {str(e)}")

    def get_circuit_layers(self):
        """Convert circuit configuration into gate layers."""
        layers = []
        for col in range(self.num_layers):
            layer_gates = []
            # Check for CNOT gate
            cnot_key = (col, "CNOT")
            if cnot_key in self.circuit:
                control_row, target_row = self.circuit[cnot_key]
                cnot_matrix = StandardGate.CNOT.value
                layer_gates.append(QuantumGate(cnot_matrix, [control_row, target_row]))
            else:
                # Process single-qubit gates
                for row in range(self.num_qubits):
                    key = (row, col)
                    if key in self.circuit:
                        gate_info = self.circuit[key]
                        if isinstance(gate_info, dict) and gate_info.get('type') == 'Custom':
                            # Custom gate
                            matrix = gate_info['matrix']
                            layer_gates.append(QuantumGate(matrix, [row]))
                        else:
                            # Standard gate
                            gate_type = gate_info
                            matrix = self._get_gate_matrix(gate_type)
                            layer_gates.append(QuantumGate(matrix, [row]))
            layers.append(layer_gates)
        return layers
    
    def _get_gate_matrix(self, gate_type):
        """Get the matrix for a standard gate type."""
        if gate_type == 'Y':
            return [[0, -1j], [1j, 0]]
        elif gate_type == 'Z':
            return [[1, 0], [0, -1]]
        elif gate_type == 'X':
            return StandardGate.PAULI_X.value
        elif gate_type == 'H':
            return StandardGate.HADAMARD.value
        else:
            raise ValueError(f"Unsupported gate type: {gate_type}")


    def plot_probabilities(self, probabilities, state_evolution):

        if RUN_ON_HARDWARE:
            plt.rcParams['axes.facecolor'] = COLORS['background']
            plt.rcParams['axes.edgecolor'] = COLORS['surface']
            plt.rcParams['axes.grid'] = True
            plt.rcParams['grid.color'] = COLORS['surface']
            plt.rcParams['grid.alpha'] = 0.2
            plt.rcParams['grid.linestyle'] = '--'
    
            num_states = len(probabilities)
            fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(15, 5))
            fig.patch.set_facecolor(COLORS['toolbar'])
    
            fig.suptitle("Simulation Results", fontsize=18, 
                         fontweight='bold', fontfamily='serif', color=COLORS['on_background'])
    
            bar_colors = [COLORS['gate'][gate] if gate in COLORS['gate'] 
                          else COLORS['primary'] for gate in 
                          ['H', 'X', 'Y', 'Z', 'CNOT', 'Custom']]
            bars = ax1.bar(range(num_states), probabilities, 
                           color=bar_colors[:num_states])
            for bar in bars:
                bar.set_edgecolor(COLORS['surface'])
                bar.set_linewidth(1)
                bar.set_alpha(0.9)
    
            ax1.set_facecolor(COLORS['background'])
            ax1.set_xlabel("State", fontsize=12, fontweight='bold',
                           fontfamily='serif', color=COLORS['on_background'])
            ax1.set_ylabel("Probability", fontsize=12, fontweight='bold',
                           fontfamily='serif', color=COLORS['on_background'])
            ax1.set_title("Quantum State Distribution", fontsize=14,
                          fontweight='bold', fontfamily='serif',
                          color=COLORS['on_background'])
            ax1.set_xticks(range(num_states))
    
            subscripts = "₀₁₂₃₄₅₆₇₈₉"
            state_labels = []
            for i in range(num_states):
                binary = format(i, f'0{self.num_qubits}b')
                subscripted_binary = ''.join(
                    f"q{subscripts[j]}={bit} " for j, bit in enumerate(binary)
                )
                state_labels.append(subscripted_binary.strip())
    
            ax1.set_xticklabels(state_labels, color=COLORS['on_background'],
                                rotation=45, ha='right', fontfamily='serif')
            ax1.tick_params(colors=COLORS['on_background'])
            ax1.grid(True, alpha=0.2, linestyle='--', color=COLORS['surface'])
            ax1.spines['top'].set_visible(False)
            ax1.spines['right'].set_visible(False)
            for spine in ax1.spines.values():
                spine.set_color(COLORS['surface'])
    
            evolution_data = np.hstack(state_evolution)
            total_time_steps = evolution_data.shape[1]
            time_axis = np.arange(total_time_steps)
            colors = [
                COLORS['gate']['H'], COLORS['gate']['X'], COLORS['gate']['Y'],
                COLORS['gate']['Z'], COLORS['gate']['CNOT'], COLORS['gate']['Custom']
            ]
    
            ax2.set_facecolor(COLORS['background'])

              # before the loop, pick a smoothing strength
            smooth_sigma = 4

            for i in range(num_states):
                # raw probabilities over time
                prob_evolution = np.abs(evolution_data[i, :])**2

                # --- NEW: apply Gaussian smoothing along the time axis ---
                prob_smooth = gaussian_filter1d(prob_evolution, sigma=smooth_sigma)

                # build your label as before
                binary = format(i, f'0{self.num_qubits}b')
                sub = ''.join(f"q{subscripts[j]}={bit} " 
                              for j, bit in enumerate(binary))

                # plot the _smoothed_ curve instead of the raw one
                ax2.plot(
                    time_axis,
                    prob_smooth,                # <-- use the smoothed data
                    label=sub.strip(),
                    linewidth=2.5,
                    color=colors[i % len(colors)],
                    marker='o',
                    markersize=4,
                    markevery=max(1, total_time_steps//10)
                )


            #for i in range(num_states):
            #    prob_evolution = np.abs(evolution_data[i, :])**2
            #    binary = format(i, f'0{self.num_qubits}b')
            #    sub = ''.join(f"q{subscripts[j]}={bit} " 
            #                  for j, bit in enumerate(binary))
            #    ax2.plot(time_axis, prob_evolution,
            #             label=sub.strip(),
            #             linewidth=2.5,
            #             color=colors[i % len(colors)],
            #             marker='o',
            #             markersize=4,
            #             markevery=max(1, total_time_steps//10))
    
            ax2.set_xlabel("Time step", fontsize=12, fontweight='bold',
                           fontfamily='serif', color=COLORS['on_background'])
            ax2.set_ylabel("Probability", fontsize=12, fontweight='bold',
                           fontfamily='serif', color=COLORS['on_background'])
            ax2.set_title("State Evolution Over Time", fontsize=14,
                          fontweight='bold', fontfamily='serif',
                          color=COLORS['on_background'])
    
            legend = ax2.legend(frameon=True, fancybox=True,
                                facecolor=COLORS['background'],
                                edgecolor=COLORS['surface'],
                                labelcolor=COLORS['toolbar'],
                                fontsize=10)
            legend.get_frame().set_alpha(0.9)
    
            ax2.tick_params(colors=COLORS['on_background'])
            ax2.grid(True, alpha=0.2, linestyle='--', color=COLORS['surface'])
            ax2.spines['top'].set_visible(False)
            ax2.spines['right'].set_visible(False)
            for spine in ax2.spines.values():
                spine.set_color(COLORS['surface'])
    
            boundaries = []
            cum_steps = 0
            for mat in state_evolution:
                cum_steps += mat.shape[1]
                boundaries.append(cum_steps)
    
            for b in boundaries[:-1]:
                ax2.axvline(x=b, color=COLORS['surface'],
                            linestyle='--', alpha=0.3, linewidth=1.5)
                ax2.annotate('Layer', xy=(b, 0.02),
                             xytext=(0, -20), textcoords='offset points',
                             ha='center', color=COLORS['on_background'],
                             fontsize=8, fontfamily='serif', rotation=90)
    
            plt.tight_layout(rect=[0, 0, 1, 0.95])
            plt.show()

        else:
                    # ——— Same setup and styling (branch 2) ———
            plt.rcParams['axes.facecolor'] = COLORS['background']
            plt.rcParams['axes.edgecolor'] = COLORS['surface']
            plt.rcParams['axes.grid'] = True
            plt.rcParams['grid.color'] = COLORS['surface']
            plt.rcParams['grid.alpha'] = 0.2
            plt.rcParams['grid.linestyle'] = '--'
    
            num_states = len(probabilities)
            fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(15, 5))
            fig.patch.set_facecolor(COLORS['toolbar'])
    
            fig.suptitle("Simulation Results", fontsize=18, 
                         fontweight='bold', fontfamily='serif', color=COLORS['on_background'])
    
            bar_colors = [COLORS['gate'][gate] if gate in COLORS['gate'] 
                          else COLORS['primary'] for gate in 
                          ['H', 'X', 'Y', 'Z', 'CNOT', 'Custom']]
            bars = ax1.bar(range(num_states), probabilities, 
                           color=bar_colors[:num_states])
            for bar in bars:
                bar.set_edgecolor(COLORS['surface'])
                bar.set_linewidth(1)
                bar.set_alpha(0.9)
    
            ax1.set_facecolor(COLORS['background'])
            ax1.set_xlabel("State", fontsize=12, fontweight='bold',
                           fontfamily='serif', color=COLORS['on_background'])
            ax1.set_ylabel("Probability", fontsize=12, fontweight='bold',
                           fontfamily='serif', color=COLORS['on_background'])
            ax1.set_title("Quantum State Distribution", fontsize=14,
                          fontweight='bold', fontfamily='serif',
                          color=COLORS['on_background'])
            ax1.set_xticks(range(num_states))
    
            subscripts = "₀₁₂₃₄₅₆₇₈₉"
            state_labels = []
            for i in range(num_states):
                binary = format(i, f'0{self.num_qubits}b')
                subscripted_binary = ''.join(
                    f"q{subscripts[j]}={bit} " for j, bit in enumerate(binary)
                )
                state_labels.append(subscripted_binary.strip())
    
            ax1.set_xticklabels(state_labels, color=COLORS['on_background'],
                                rotation=45, ha='right', fontfamily='serif')
            ax1.tick_params(colors=COLORS['on_background'])
            ax1.grid(True, alpha=0.2, linestyle='--', color=COLORS['surface'])
            ax1.spines['top'].set_visible(False)
            ax1.spines['right'].set_visible(False)
            for spine in ax1.spines.values():
                spine.set_color(COLORS['surface'])
    
            evolution_data = np.hstack(state_evolution)
            total_time_steps = evolution_data.shape[1]
            time_axis = np.arange(total_time_steps)
            colors = [
                COLORS['gate']['H'], COLORS['gate']['X'], COLORS['gate']['Y'],
                COLORS['gate']['Z'], COLORS['gate']['CNOT'], COLORS['gate']['Custom']
            ]
    
            ax2.set_facecolor(COLORS['background'])
            for i in range(num_states):
                prob_evolution = np.abs(evolution_data[i, :])**2
                binary = format(i, f'0{self.num_qubits}b')
                sub = ''.join(f"q{subscripts[j]}={bit} " 
                              for j, bit in enumerate(binary))
                ax2.plot(time_axis, prob_evolution,
                         label=sub.strip(),
                         linewidth=2.5,
                         color=colors[i % len(colors)],
                         marker='o',
                         markersize=4,
                         markevery=max(1, total_time_steps//10))
    
            ax2.set_xlabel("Time step", fontsize=12, fontweight='bold',
                           fontfamily='serif', color=COLORS['on_background'])
            ax2.set_ylabel("Probability", fontsize=12, fontweight='bold',
                           fontfamily='serif', color=COLORS['on_background'])
            ax2.set_title("State Evolution Over Time", fontsize=14,
                          fontweight='bold', fontfamily='serif',
                          color=COLORS['on_background'])
    
            legend = ax2.legend(frameon=True, fancybox=True,
                                facecolor=COLORS['background'],
                                edgecolor=COLORS['surface'],
                                labelcolor=COLORS['toolbar'],
                                fontsize=10)
            legend.get_frame().set_alpha(0.9)
    
            ax2.tick_params(colors=COLORS['on_background'])
            ax2.grid(True, alpha=0.2, linestyle='--', color=COLORS['surface'])
            ax2.spines['top'].set_visible(False)
            ax2.spines['right'].set_visible(False)
            for spine in ax2.spines.values():
                spine.set_color(COLORS['surface'])
    
            boundaries = []
            cum_steps = 0
            for mat in state_evolution:
                cum_steps += mat.shape[1]
                boundaries.append(cum_steps)
    
            for b in boundaries[:-1]:
                ax2.axvline(x=b, color=COLORS['surface'],
                            linestyle='--', alpha=0.3, linewidth=1.5)
                ax2.annotate('Layer', xy=(b, 0.02),
                             xytext=(0, -20), textcoords='offset points',
                             ha='center', color=COLORS['on_background'],
                             fontsize=8, fontfamily='serif', rotation=90)
    
            plt.tight_layout(rect=[0, 0, 1, 0.95])
            plt.show()
    
    
    
if __name__ == '__main__':
    app = QApplication(sys.argv)
    app.setStyle("Fusion")  # Better dark theme support
    
    # Create the main window
    window = MainWindow(num_qubits=1, num_layers=4)
    
    # Detect WSL (Windows Subsystem for Linux)
    is_wsl = False
    try:
        with open('/proc/version', 'r') as f:
            if 'microsoft' in f.read().lower():
                is_wsl = True
                print("WSL detected, applying specific window styling")
    except:
        pass
    
    # Platform-specific window styling
    if sys.platform == "win32":
        # Windows-specific dark title bar
        try:
            import ctypes
            app_id = 'quantum.circuit.designer.1.0'
            ctypes.windll.shell32.SetCurrentProcessExplicitAppUserModelID(app_id)
            
            DWMWA_USE_IMMERSIVE_DARK_MODE = 20
            hwnd = window.winId()
            ctypes.windll.dwmapi.DwmSetWindowAttribute(
                hwnd, DWMWA_USE_IMMERSIVE_DARK_MODE, 
                ctypes.byref(ctypes.c_int(1)), ctypes.sizeof(ctypes.c_int)
            )
        except Exception as e:
            print(f"Could not set Windows dark mode: {e}")
    
    # Special handling for WSL
    if is_wsl:
        window.setStyleSheet(window.styleSheet() + """
            QMainWindow {
                border: none;
            }
            
            QMainWindow::title {
                background-color: #704214;
                color: white;
            }
            
            QMainWindow > .QWidget {
            
                background-color: #704214;
            }
        """)
    
    # Show window and start event loop
    window.show()
    sys.exit(app.exec_())

