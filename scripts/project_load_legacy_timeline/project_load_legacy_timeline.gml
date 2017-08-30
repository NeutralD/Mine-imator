/// project_load_legacy_timeline()

with (new(obj_timeline))
{
	loaded = true

	save_id = buffer_read_int()
	save_id_map[?save_id] = save_id
	
	type = buffer_read_string_int()
	name = buffer_read_string_int()
	temp = project_load_legacy_save_id()
	text = buffer_read_string_int()
	color = buffer_read_int()
	if (load_format < e_project.FORMAT_100_DEBUG) // Color too bright
		color = make_color_hsv(color_get_hue(color), 255, 128)

	lock = buffer_read_byte()
	if (load_format < e_project.FORMAT_100_DEBUG)
		lock = !lock
	if (load_format >= e_project.FORMAT_100_DEBUG)
		depth = buffer_read_int()

	legacy_bodypart_id = buffer_read_short()
	if (type = "bodypart")
	{
		// Find part model
		var findtemp;
		with (obj_template)
		{
			if (loaded && save_id = other.temp)
			{
				temp_update_model_state_map()
				temp_update_model()
				findtemp = id
				break
			}
		}
		
		// Find name from ID
		var modelpartlist = legacy_model_part_map[?findtemp.legacy_model_name];
		model_part_name = modelpartlist[|legacy_bodypart_id]
		
		// Find part model by looking through model file for the name
		var filepartlist = findtemp.model_file.file_part_list;
		for (var i = 0; i < ds_list_size(filepartlist); i++)
		{
			var part = filepartlist[|i];
			if (part.name = model_part_name)
			{
				model_part = part
				break
			}
		}
	}
	
	project_load_legacy_save_id() // part_of
	
	if (type = "char" || type = "spblock")
		part_list = ds_list_create()
		
	part_amount = buffer_read_short()
	for (var p = 0; p < part_amount; p++)
		ds_list_add(part_list, project_load_legacy_save_id())

	hide = buffer_read_byte()
	
	if (load_format >= e_project.FORMAT_100_DEMO_3)
		project_load_legacy_value_types()
	else
		tl_update_value_types()

	if (load_format >= e_project.FORMAT_100_DEMO_4)
		project_load_legacy_values(id)

	keyframe_amount = buffer_read_int()
	if (keyframe_amount = 0)
		for (var v = 0; v < e_value.amount; v++)
			value_default[v] = value[v]

	for (var k = 0; k < keyframe_amount; k++)
	{
		with (new(obj_keyframe))
		{
			loaded = true
			position = buffer_read_int()
			timeline = other.id
			selected = false
			sound_play_index = null
			
			for (var v = 0; v < e_value.amount; v++)
				value[v] = other.value[v]
			project_load_legacy_values(other.id)
			
			ds_list_add(other.keyframe_list, id)
		}
	}
	
	parent = project_load_legacy_save_id()
	if (load_format >= e_project.FORMAT_100_DEBUG)
		parent_tree_index = buffer_read_int()
	else
		parent_tree_index = null

	lock_bend = buffer_read_byte()

	if (load_format < e_project.FORMAT_100_DEBUG)
	{
		repeat (buffer_read_int())
			buffer_read_int()
	}

	tree_extend = buffer_read_byte()
	inherit_position = buffer_read_byte()
	inherit_rotation = buffer_read_byte()
	inherit_scale = buffer_read_byte()
	inherit_alpha = buffer_read_byte()
	inherit_color = buffer_read_byte()
	inherit_texture = buffer_read_byte()
	inherit_visibility = buffer_read_byte()
	scale_resize = buffer_read_byte()
	rot_point_custom = buffer_read_byte()

	rot_point[X] = buffer_read_double()
	rot_point[Y] = buffer_read_double()
	rot_point[Z] = buffer_read_double()
	if (rot_point_custom && load_format < e_project.FORMAT_100_DEBUG && type_is_shape(type))
	{
		rot_point[X] -= 8
		rot_point[Y] -= 8
		if (type != "surface")
			rot_point[Z] -= 8
	}
	
	backfaces = buffer_read_byte()
	texture_blur = buffer_read_byte()
	if (load_format >= e_project.FORMAT_100_DEBUG)
		texture_filtering = buffer_read_byte()
	else
		texture_filtering = (type = "scenery" || type="block")
	round_bending = buffer_read_byte()
	shadows = buffer_read_byte()
	if (load_format >= e_project.FORMAT_100_DEBUG)
	{
		ssao = buffer_read_byte()
		if (load_format >= e_project.FORMAT_105_2)
			fog = buffer_read_byte()
		wind = buffer_read_byte()
		wind_amount = buffer_read_double()
	}
	wind_terrain = buffer_read_byte()

	if (load_format >= e_project.FORMAT_CB_100) 
	{
		/*inherit_bend = */buffer_read_byte()
		/*hide_quality_high = */buffer_read_byte()
		/*hide_quality_low = */buffer_read_byte()
		/*biome = */buffer_read_byte()
	}
}