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

loadlib $P1, 'evas_cb_helper'
if $P1 goto has_evas_cb_helper_lib
say "Couldn't load evas_cb_helper"
exit 1
has_evas_cb_helper_lib:
dlfunc $P2, $P1, 'make_evas_cb_helper', 'PJPPS'
set_global 'make_evas_cb_helper', $P2

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

.namespace ['Elementary';'Widget']

.sub '' :anon :load :init
    .local pmc ns, cl
    ns = get_namespace
    cl = newclass ns
    addattribute cl, 'widget'
    addattribute cl, 'class'
    set_hll_global ['Elementary'], 'Widget', cl
.end

.sub 'make-subclasses' :anon :load :init
    .local pmc parent, list, i, ns, cl
    .local string item
    parent = get_hll_global ['Elementary'], 'Widget'
    list = split ' ', 'win box bg label frame button'
    i = new ['Iterator'], list
  loop:
    unless i goto loop_end
    item = shift i
    ns = get_hll_namespace ['Elementary';item]
    if_null ns, loop
    cl = subclass parent, ns
    set_hll_global ['Elementary'], item, cl
    goto loop
  loop_end:
.end

.sub new
    die 'Abstract base class... only instantiate subclasses'
.end

.sub 'add_callback' :method
    .param string event
    .param pmc function
    .param pmc user_data
    .local pmc cb, win
    cb = 'make_evas_cb_helper'(function, user_data, 'vUpp')
    win = getattribute self, 'widget'
    'evas_object_smart_callback_add'(win, event, cb, user_data)
.end

.sub 'widget_add' :method
    .param string type
    .param num x
    .param num y
    .local pmc obj, widget, cl
    .local string func
    func = concat 'elm_', type
    func = concat func, '_add'
    widget = getattribute self, 'widget'
    $P0 = get_hll_global ['Elementary'], func
    widget = $P0(widget)
    'evas_object_size_hint_weight_set'(widget,1.0,1.0)
    cl = get_hll_global ['Elementary'], type
    if_null cl, no_class
    obj = new cl
    setattribute obj, 'widget', widget
    $P0 = box type
    setattribute obj, 'class', $P0
    .return (obj)
  no_class:
    .return (widget)
.end

.sub 'show' :method
    .local pmc obj
    obj = getattribute self, 'widget'
    'evas_object_show'(obj)
.end


.namespace ['Elementary';'win']

.sub 'new'
    .param pmc parent
    .param string name
    .param int type
    .local pmc win, cl, obj
    win = 'elm_win_add'(parent, name, type)
    'elm_win_title_set'(win, name)
    cl = get_hll_global ['Elementary'], 'win'
    obj = new cl
    setattribute obj, 'widget', win
    $P0 = box 'win'
    setattribute obj, 'class', $P0
    .return (obj)
.end

.sub 'resize_object_add' :method
    .param pmc obj
    .local pmc win
    win = getattribute self, 'widget'
    $I0 = isa obj, 'UnManagedStruct'
    if $I0 goto unmanaged
    obj = getattribute obj, 'widget'
  unmanaged:
    'elm_win_resize_object_add'(win,obj)
.end
.namespace ['Elementary';'box']

.sub 'pack_end' :method
    .param pmc obj
    .local pmc box
    box = getattribute self, 'widget'
    'elm_box_pack_end'(box,obj)
.end

.namespace ['Elementary';'bg']

.sub 'file_set' :method
    .param string file
    .param string group
    say "file_set NYI"
.end
# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:
