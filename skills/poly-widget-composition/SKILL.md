---
name: poly-widget-composition
description: Monoidal widget composition via tensor products, string diagrams, and braided categories using Poly
---

# Poly Widget Composition

## Categorical Foundation

Widget composition forms a **monoidal category** with:
- **(⊗)**: Tensor product - horizontal (parallel) composition
- **(+)** : Coproduct - vertical (choice) composition
- **String diagrams**: Commutative diagrams for visual composition

## Core Concept: Widget Monoid

```julia
using Poly

# Widgets form a monoidal category (W, ⊗, unit)
#
# - Identity: single widget
# - Tensor: horizontal composition (side by side)
# - Unit: empty widget

widget1 = Text("Hello")
widget2 = Text("World")

# Horizontal: both display together
combined = widget1 ⊗ widget2
```

## Composition Operators

### Tensor (Horizontal)

```julia
# Side-by-side composition: (⊗)
horizontal = button ⊗ label ⊗ input

# This is the tensor in the monoidal category
```

### Sequential

```julia
# Top-to-bottom composition: (▷)
vertical = header ▷ content ▷ footer

# Sequential layout - output of one feeds to next
```

### Choice

```julia
# Alternative (coproduct): (+)
alternatives = tab1 + tab2 + tab3

# Tab selection - any one shown
```

## Widget Types

### Primitive Widgets

```julia
# Text display
text = Text("Hello, World!")

# Button
button = Button("Click me", on_click)

# Input field  
input = Input(placeholder="Enter text...")

# Image
image = Image(src="image.png")
```

### Container Widgets

```julia
# Vertical stack
vstack([widget1, widget2, widget3])

# Horizontal stack
hstack([widget1, widget2])

# Grid
grid(rows=3, cols=3)
```

## String Diagrams

Widget composition is captured by **string diagrams**:

```julia
# String diagram for: (f ⊗ g) ▷ h
#
#     f     g
#     │     │
#     ├─────┤
#         │
#         h
#         │

diagram = (f ⊗ g) ▷ h
```

### Drawing

```julia
# Render the string diagram
using Poly.Diagrams

draw(diagram)
```

## Monoidal Structures

### The Four Monoidal Structures on Widgets

| Structure | Tensor | Unit | Description |
|-----------|--------|------|-------------|
| Sequential (▷) | composition | identity | Function application |
| Parallel (⊗) | side-by-side | empty | Layout |
| Choice (+) | tabs | none | Alternative |
| Product (×) | both render | unit | Intersection |

### Braiding

```julia
# Swap widgets: σ: A ⊗ B → B ⊗ A
swap = braid(widget_a, widget_b)

# For layout reordering
```

## Layout Composition

### Vertical Stack

```julia
# VStack: sequential composition
header = title_widget ⊗ subtitle_widget
content = form_widget ⊗ button_widget
footer = copyright_widget

app = header ▷ content ▷ footer
```

### Horizontal Layout

```julia
# Side-by-side
sidebar ⊗ main_content

# With proportional sizing  
sidebar ⊗ (2 * main_content)
```

### Grid Layout

```julia
# Grid with placement
grid = Grid(rows=3, cols=3)
grid[1, 1:3] = header
grid[2, 1] = sidebar
grid[2, 2:3] = main_content  
grid[3, :] = footer
```

## Composing Behaviors

### Event Handling

```julia
# Compose event handlers
handler = on_click(button1) ⊗ on_hover(image)

# Sequential: first, then second
handler1 ▷ handler2

# Parallel: both active
handler1 ⊗ handler2
```

### State Updates

```julia
# State computation composition
state1 = compute_state(data1)
state2 = compute_state(data2)

# Combined state
combined_state = state1 ⊗ state2

# Sequential update
final_state = state1 ▷ state2
```

## The Monoidal Category

### Identity Laws

```julia
# Left identity
empty ⊗ widget == widget

# Right identity
widget ⊗ empty == widget

# Associativity
(widget1 ⊗ widget2) ⊗ widget3 == widget1 ⊗ (widget2 ⊗ widget3)
```

### Unit

```julia
# Empty widget (unit of ⊗)
empty = EmptyWidget()

# No-op (unit of ▷)  
identity = IdentityWidget()
```

## Advanced Composition

### Conditional Rendering

```julia
# Show one of many: coproduct
tab1 + tab2 + tab3

# Selection determines which renders
selected = tabs(active_tab) ⊗ (tab1 + tab2 + tab3)
```

### Recursive Layouts

```julia
# Tree structure via recursion
function tree_widget(node)
    if is_leaf(node)
        return Text(node.value)
    else
        return tree_widget(node.left) ⊗ tree_widget(node.right)
    end
end
```

## Integration

Use with:
- **superpowers:poly-ui-representation** - Data representation
- **superpowers:compound-feedback-loop** - Visualize benchmarks

## Key Principles

1. **Monoidal category** - Widgets compose with ⊗, ▷, +
2. **String diagrams** - Visual representation of composition
3. **Braided** - Can swap positions naturally
4. **Universal** - Identity and unit laws hold

## References

- Poly.Modes: Layout widgets
- Poly.Diagrams: String diagrams
- Monoidal structures: See CLAUDE.md
