/// project_write_project()

buffer_write_string_int(project_name)
buffer_write_string_int(project_author)
buffer_write_string_int(project_description)
buffer_write_int(project_video_width)
buffer_write_int(project_video_height)
buffer_write_byte(project_video_keep_aspect_ratio)
buffer_write_byte(project_tempo)
buffer_write_byte(timeline_repeat)
buffer_write_double(timeline_marker)
buffer_write_double(timeline.hor_scroll.value)
buffer_write_double(timeline_zoom)
buffer_write_int(timeline_region_start)
buffer_write_int(timeline_region_end)