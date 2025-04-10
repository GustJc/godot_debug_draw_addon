3D debug draw addon for Godot Engine
====================================

This is a simple debug draw addon for 3D shapes.

Its a gdscript addon that is easy to use and call debug draw functions to help test your code.

Shapes drawn can be called every frame, or only once if a duration is passed.

This uses a `MultiMesh` to instanciate each type of 3D shape.
So it should be able to support a lot of shapes at the same time.
The downside is that it can't cull unseen shapes.
Not sure if this was the right approach, but it shouldn't affect the game performance in any meaningful way.

There is also an alternate method of drawing with `ImmediateMesh` where the shapes are drawn and cleared each frames. \
Those draws functions are noted the letter `q`. eg: `qdraw_line()`

This addon will add an autoload to control and show the debug shapes.
You can access it by calling `DebugDraw`.

Work to do
-------------------
As of now, each new shape added needs a new MultiMesh node.\
Each with `DebugDraw.MAX_SHAPES_PER_TYPE` instances. \
This config will be a project setting in the future.

The multimesh re-uses previously _freed_ instances but it doesn't renew the max `visible_instance_count`.

The `examples` folder right now is just temporary testing. \
I'll replace it with proper examples after the basic work is done


Shapes to add:
- Pointy line/arrows
- Box shape
- Wireframe shapes (using shader)
- Label3D (not multimesh, but using a pool as needed)

I might abandon the multimesh approach and just use normal instancing for extra shapes.

Install
-------------------
Just enable the addon and you should be able to use the `DebugDraw` functions.

Usable Functions
-------------------

### Lines

```gdscript
## Draw a line
func draw_line(pointA : Vector3, pointB : Vector3, color: Color = Color.RED, duration: float = 0.0):
```

```gdscript
## Draw a thick line.
func draw_line_thick(pointA : Vector3, pointB : Vector3, thickness: float = 2.0, color: Color = Color.BLACK, duration: float = 0.0):
```

```gdscript
## Draw a ray. Its a line where you pass its position and direction.
func draw_ray(pointA : Vector3, dir_len : Vector3, color: Color = Color.RED, duration: float = 0.0):
```


```gdscript
## Draw a ray with a thick line.
func draw_ray_thick(pointA : Vector3, dir_len : Vector3, thickness: float = 2.0, color: Color = Color.BLACK, duration: float = 0.0):
```

### Shapes


```gdscript
## Draw a sphere.
func draw_sphere_mm(pos: Vector3, radius: float, color: Color = Color(Color.RED, 0.85), duration: float = 0.0):
```

### Special shapes


```gdscript
## Draws a sphere with a trailing line behind. For raycasts and hits.
func draw_hit_ray(hit_pos, hit_direction, duration, hit_radius, trail_len, hit_color, trail_color)
```


```gdscript
## Same as above. But uses a thick line.
func draw_hit_ray_thick(hit_pos, hit_direction, duration, hit_radius, trail_len, trail_thickness,
hit_color, trail_color) 
```

Usable Functions (immediate draw)
-------------------
These are kinda deprecated, the first iteration of the DebugDraw used this.


```gdscript
## Draw a line.
func qdraw_line(pointA : Vector3, pointB : Vector3, color: Color = Color.BLACK):
```


```gdscript
## Draw a ray.
func qdraw_line_relative(pointA : Vector3, dir_len : Vector3, color: Color = Color.PURPLE):
```


```gdscript
## Draw a ray with a thick line.
func qdraw_line_relative_thick(pointA : Vector3, pointB : Vector3, thickness: float = 2.0, color: Color = Color.BLACK):
```


```gdscript
## Draw a ray with a pointy line. The thick line tapers a bit at the end.
func qdraw_line_relative_thickpointy`(pointA : Vector3, pointB : Vector3, thickness: float = 2.0, color: Color = Color.BLACK):
```

Usage
-------------------
Spawns a sphere where a collision happens. \
The sphere stays for 1s, before disapearing.

```gdscript
func _on_hit(hit_pos: Vector3) -> void:
    var radius := 0.5   # Creates a sphre of radius 0.5
    var duration := 1.0 # Will display debug shape for 1s

    DebugDraw.draw_sphere(hit_pos, radius, duration)
```

Usage for quick draws
-------------------
These functions needs to be called every frame.
```gdscript
func _process(_delta: float) -> void:
    if show_debug:
        DebugDraw.qdraw_ray(position, Vector3.UP, Color.RED)
```