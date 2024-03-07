# Startup
Download Source Code from the following repositories:
1. [Object_display](https://people.sc.fsu.edu/%7Ejburkardt/m_src/obj_display/obj_display.html).
2. [Obj_io](https://people.sc.fsu.edu/%7Ejburkardt/m_src/obj_io/obj_io.html).
3. Download shape_descriptor.m and sd_function_class.m

# Import .obj files

Input .obj file names into the filenames array
```
filenames = {'sphere.obj', 'shuttle.obj', 'ellipsoid.obj', 'cessna.obj'};
```

# Example Output: 
> [!NOTE]
> num_samples was decreased in order to show more clearly the sampling on the object surface
> 
> This can be edited when calling sample_surface
> 
> ```Sampled_points = sample_surface(normalized_vertices, new_face_node, num_samples);```

![image](https://github.com/Manu123456789/MECH251/assets/22645681/a39afa39-4af6-475a-af61-052033716fd5)

![image](https://github.com/Manu123456789/MECH251/assets/22645681/5e9f1523-e28c-46b5-ae7d-f164bcc79005)

![image](https://github.com/Manu123456789/MECH251/assets/22645681/58575885-aaa3-4dd3-8861-9a63904c06fa)

![image](https://github.com/Manu123456789/MECH251/assets/22645681/35ce3e0c-b7a4-4760-aa8d-c5f59ab0b89d)
