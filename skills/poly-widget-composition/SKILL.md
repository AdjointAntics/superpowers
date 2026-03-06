---
name: poly-widget-composition
description: Use when composing UI widgets with tensor/sequential/choice operators, building layouts, or handling events via monoidal composition -- uses Poly's four monoidal structures
---
# Poly Widget Composition

## When
Invoke when you need to compose widgets into layouts, combine event handlers, or build complex UIs from primitive components using Poly's composition operators.

## Iron Laws
1. Use the correct operator for intent: `<otimes>` for parallel, `<triangleright>` for sequential, `+` for choice.
2. Verify identity and associativity laws hold for composed widgets.
3. Prefer declarative composition over imperative nesting.

## Process
1. Use composition operators:
   ```julia
   horizontal = button <otimes> label <otimes> input   # parallel (side-by-side)
   vertical   = header <triangleright> content <triangleright> footer  # sequential (top-to-bottom)
   tabs       = tab1 + tab2 + tab3              # choice (one shown)
   ```
2. Create primitive widgets:
   ```julia
   text   = Text("Hello, World!")
   button = Button("Click me", on_click)
   input  = Input(placeholder="Enter text...")
   image  = Image(src="image.png")
   ```
3. Use container widgets:
   ```julia
   vstack([widget1, widget2, widget3])
   hstack([widget1, widget2])
   grid(rows=3, cols=3)
   ```
4. Build layouts:
   ```julia
   header  = title_widget <otimes> subtitle_widget
   content = form_widget <otimes> button_widget
   app     = header <triangleright> content <triangleright> footer
   ```
5. Use grid placement:
   ```julia
   grid = Grid(rows=3, cols=3)
   grid[1, 1:3] = header
   grid[2, 1]   = sidebar
   grid[2, 2:3] = main_content
   grid[3, :]   = footer
   ```
6. Compose event handlers:
   ```julia
   handler = on_click(button1) <otimes> on_hover(image)  # both active
   chain   = handler1 <triangleright> handler2            # sequential
   ```
7. Swap widget order: `swap = braid(widget_a, widget_b)`.
8. Render string diagrams: `draw(diagram)` via `Poly.Diagrams`.

### Four Monoidal Structures

| Structure | Operator | Unit | Meaning |
|-----------|----------|------|---------|
| Sequential | `<triangleright>` | identity | Function application (top-to-bottom) |
| Parallel | `<otimes>` | empty | Layout (side-by-side) |
| Choice | `+` | none | Alternative (tabs) |
| Product | `x` | unit | Intersection (both render) |

### Conditional & Recursive
```julia
selected = tabs(active_tab) <otimes> (tab1 + tab2 + tab3)  # conditional

function tree_widget(node)                          # recursive
    is_leaf(node) ? Text(node.value) :
        tree_widget(node.left) <otimes> tree_widget(node.right)
end
```

## Composability
Expects primitive widgets or polynomial functor representations from poly-ui-representation. Produces composed widget trees ready for rendering via PolyModes.jl.
