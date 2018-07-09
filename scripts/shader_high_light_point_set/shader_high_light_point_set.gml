/// shader_high_light_point_set()

render_set_uniform_int("uIsSky", 0)

render_set_uniform_int("uLightAmount", render_light_amount)
render_set_uniform_vec3("uLightPosition", render_light_from[X], render_light_from[Y], render_light_from[Z])
render_set_uniform_color("uLightColor", render_light_color, 1)
render_set_uniform("uLightNear", render_light_near)
render_set_uniform("uLightFar", render_light_far)
render_set_uniform("uLightFadeSize", render_light_fade_size)

texture_set_stage(sampler_map[?"uDepthBufferXp"], surface_get_texture(render_surface_point_buffer[0]))
texture_set_stage(sampler_map[?"uDepthBufferXn"], surface_get_texture(render_surface_point_buffer[1]))
texture_set_stage(sampler_map[?"uDepthBufferYp"], surface_get_texture(render_surface_point_buffer[2]))
texture_set_stage(sampler_map[?"uDepthBufferYn"], surface_get_texture(render_surface_point_buffer[3]))
texture_set_stage(sampler_map[?"uDepthBufferZp"], surface_get_texture(render_surface_point_buffer[4]))
texture_set_stage(sampler_map[?"uDepthBufferZn"], surface_get_texture(render_surface_point_buffer[5]))
gpu_set_texfilter_ext(sampler_map[?"uDepthBufferXp"], true)
gpu_set_texfilter_ext(sampler_map[?"uDepthBufferXn"], true)
gpu_set_texfilter_ext(sampler_map[?"uDepthBufferYp"], true)
gpu_set_texfilter_ext(sampler_map[?"uDepthBufferYn"], true)
gpu_set_texfilter_ext(sampler_map[?"uDepthBufferZp"], true)
gpu_set_texfilter_ext(sampler_map[?"uDepthBufferZn"], true)
gpu_set_texrepeat_ext(sampler_map[?"uDepthBufferXp"], false)
gpu_set_texrepeat_ext(sampler_map[?"uDepthBufferXn"], false)
gpu_set_texrepeat_ext(sampler_map[?"uDepthBufferYp"], false)
gpu_set_texrepeat_ext(sampler_map[?"uDepthBufferYn"], false)
gpu_set_texrepeat_ext(sampler_map[?"uDepthBufferZp"], false)
gpu_set_texrepeat_ext(sampler_map[?"uDepthBufferZn"], false)

if (app.setting_render_shadows_blur_size > 0)
	render_set_uniform_int("uBlurQuality", app.setting_render_shadows_blur_quality)
else
	render_set_uniform_int("uBlurQuality", 1)

if (app.setting_render_shadows_blur_quality > 1)
	render_set_uniform("uBlurSize", app.setting_render_shadows_blur_size)
else
	render_set_uniform("uBlurSize", 0)