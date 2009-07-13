# Copyright (C) 2004-2009, Parrot Foundation.
# $Id$

.namespace ['Elementary']
.sub __elementary_init :anon :load

loadlib $P1, 'libelementary'
if $P1 goto has_lib
say "Couldn't load elementary"
exit 1
has_lib:
dlfunc $P2, $P1, 'elm_init', 'v3p'
set_global 'real_elm_init', $P2
dlfunc $P2, $P1, 'elm_run', 'v'
set_global 'elm_run', $P2
dlfunc $P2, $P1, 'elm_exit', 'v'
set_global 'elm_exit', $P2
dlfunc $P2, $P1, 'elm_shutdown', 'v'
set_global 'elm_shutdown', $P2
dlfunc $P2, $P1, 'elm_win_add', 'ppti'
set_global 'elm_win_add', $P2
dlfunc $P2, $P1, 'elm_bg_add', 'pp'
set_global 'elm_bg_add', $P2
dlfunc $P2, $P1, 'elm_label_add', 'pp'
set_global 'elm_label_add', $P2

dlfunc $P2, $P1, 'elm_box_add', 'pp'
set_global 'elm_box_add', $P2
dlfunc $P2, $P1, 'elm_box_pack_end', 'vpp'
set_global 'elm_box_pack_end', $P2
dlfunc $P2, $P1, 'elm_box_horizontal_set', 'vpi'
set_global 'elm_box_horizontal_set', $P2
dlfunc $P2, $P1, 'elm_box_homogenous_set', 'vpi'
set_global 'elm_box_homogenous_set', $P2

dlfunc $P2, $P1, 'elm_button_add', 'pp'
set_global 'elm_button_add', $P2
dlfunc $P2, $P1, 'elm_button_label_set', 'vpt'
set_global 'elm_button_label_set', $P2

dlfunc $P2, $P1, 'elm_frame_add', 'pp'
set_global 'elm_frame_add', $P2
dlfunc $P2, $P1, 'elm_frame_content_set', 'vpp'
set_global 'elm_frame_content_set', $P2
dlfunc $P2, $P1, 'elm_frame_style_set', 'vpt'
set_global 'elm_frame_style_set', $P2
dlfunc $P2, $P1, 'elm_win_title_set', 'vpt'
set_global 'elm_win_title_set', $P2
dlfunc $P2, $P1, 'elm_label_label_set', 'vpt'
set_global 'elm_label_label_set', $P2
dlfunc $P2, $P1, 'elm_win_resize_object_add', 'vpp'
set_global 'elm_win_resize_object_add', $P2

loadlib $P1, 'libevas'
if $P1 goto has_evas_lib
say "Couldn't load evas"
exit 1
has_evas_lib:
dlfunc $P2, $P1, 'evas_object_show', 'vp'
set_global 'evas_object_show', $P2
dlfunc $P2, $P1, 'evas_object_size_hint_weight_set', 'vpff'
set_global 'evas_object_size_hint_weight_set', $P2
dlfunc $P2, $P1, 'evas_object_smart_callback_add', 'vptpp'
set_global 'evas_object_smart_callback_add', $P2

.begin_return
.end_return
.end

.sub 'elm_init'
    .param pmc argv
    load_bytecode 'NCI/call_toolkit_init.pbc'
    .local pmc cti, ei
    cti = get_root_global ['parrot';'NCI'], 'call_toolkit_init'
    ei = get_global 'real_elm_init'
    argv = cti(ei, argv)
    .return (argv)
.end
# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:
