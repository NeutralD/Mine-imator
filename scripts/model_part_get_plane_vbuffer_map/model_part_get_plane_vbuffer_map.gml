/// model_part_get_plane_vbuffer_map(part, map, resource, texturenamemap)
/// @arg part
/// @arg map
/// @arg resource
/// @arg texturenamemap
/// @desc Clears and fills the given map with vbuffers for 3D planes,
///		  with the given resource selected as a texture.

var part, map, res, texnamemap;
part = argument0
map = argument1
res = argument2
texnamemap = argument3

if (part.shape_list = null)
	return 0
	
var parttexname = model_part_get_texture_name(part, texnamemap);

// Create vertex buffer for each 3D plane
draw_texture_start()
for (var s = 0; s < ds_list_size(part.shape_list); s++)
{
	var shape = part.shape_list[|s];
	if (shape.type != "plane" || !shape.is3d)
		continue
				
	// Get texture (shape texture overrides part texture)
	var shapetexname = parttexname;
	if (shape.texture_name != "")
		shapetexname = shape.texture_name
				
	var tex, texsize;
	with (res)
		tex = res_get_model_texture(shapetexname)
				
	if (tex = null)
		continue
		
	// Create surface from texture
	var surf, texsize;
	texsize = vec2(shape.to_noscale[X] - shape.from_noscale[X], shape.to_noscale[Z] - shape.from_noscale[Z])
	surf = surface_create(texsize[X], texsize[Y])
	render_set_culling(false)
	surface_set_target(surf)
	{
		draw_clear_alpha(c_black, 0)
		if (shape.texture_mirror)
			draw_texture_part(tex, texsize[X], 0, shape.uv[X], shape.uv[Y], texsize[X], texsize[Y], -1, 1)
		else
			draw_texture_part(tex, 0, 0, shape.uv[X], shape.uv[Y], texsize[X], texsize[Y])
	}
	surface_reset_target()
	render_set_culling(true)
	
	// Generate 3D pixels
	vertex_brightness = shape.color_brightness
	
	map[?shape] = vbuffer_start();
	vbuffer_add_pixels(surf, shape.from, texsize[Y], array_copy_1d(shape.uv), texsize, vec2_div(vec2(1), shape.texture_size), shape.scale, shape.texture_mirror, shape.color_blend, shape.color_alpha)
	vbuffer_done()
	
	vertex_brightness = 0
}
draw_texture_done()