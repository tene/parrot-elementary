# Copyright (C) 2004-2009, Parrot Foundation.
# $Id$

.macro export_dl_func(lib, name, sig)
    .local pmc edlftmp
    dlfunc edlftmp, .lib, .name, .sig
    set_global .name, edlftmp
.endm


.namespace ['Elementary']
.sub __elementary_init :anon :load

loadlib $P1, 'libelementary'
if $P1 goto has_lib
say "Couldn't load elementary"
exit 1
has_lib:
dlfunc $P2, $P1, 'elm_init', 'v3p'
set_global 'real_elm_init', $P2
.export_dl_func($P1, 'elm_run', 'v')
.export_dl_func($P1, 'elm_exit', 'v')
.export_dl_func($P1, 'elm_shutdown', 'v')
.export_dl_func($P1, 'elm_win_add', 'ppti')
.export_dl_func($P1, 'elm_bg_add', 'pp')
.export_dl_func($P1, 'elm_label_add', 'pp')

.export_dl_func($P1, 'elm_box_add', 'pp')
.export_dl_func($P1, 'elm_box_pack_end', 'vpp')
.export_dl_func($P1, 'elm_box_horizontal_set', 'vpi')
.export_dl_func($P1, 'elm_box_homogenous_set', 'vpi')

.export_dl_func($P1, 'elm_button_add', 'pp')
.export_dl_func($P1, 'elm_button_label_set', 'vpt')
.export_dl_func($P1, 'elm_button_style_set', 'vpt')

.export_dl_func($P1, 'elm_frame_add', 'pp')
.export_dl_func($P1, 'elm_frame_content_set', 'vpp')
.export_dl_func($P1, 'elm_frame_style_set', 'vpt')
.export_dl_func($P1, 'elm_win_title_set', 'vpt')
.export_dl_func($P1, 'elm_label_label_set', 'vpt')
.export_dl_func($P1, 'elm_win_resize_object_add', 'vpp')

loadlib $P1, 'libevas'
if $P1 goto has_evas_lib
say "Couldn't load evas"
exit 1
has_evas_lib:
.export_dl_func($P1, 'evas_object_show', 'vp')
.export_dl_func($P1, 'evas_object_size_hint_weight_set', 'vpff')
.export_dl_func($P1, 'evas_object_smart_callback_add', 'vptpp')

loadlib $P1, 'evas_cb_helper'
if $P1 goto has_evas_cb_helper_lib
say "Couldn't load evas_cb_helper"
exit 1
has_evas_cb_helper_lib:
.export_dl_func($P1, 'make_evas_cb_helper', 'PJPPS')

.begin_return
.end_return
.end

.sub 'elm_init'
    .param pmc argv
    .param pmc name :optional
    .param int has_name :opt_flag
    $P0 = compreg 'parrot'
    $P0.'import'('NCI::Utils')
    .local pmc cti, ei
    ei = get_global 'real_elm_init'
    if has_name goto with_name
    argv = 'call_toolkit_init'(ei, argv)
    .return (argv)
  with_name:
    argv = 'call_toolkit_init'(ei, argv, name)
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
    $P0 = compreg 'parrot'
    $P0.'import'('Elementary')
.end

.sub 'make-subclasses' :anon :load :init
    .local pmc parent, list, i, ns, cl, compiler
    .local string item
    compiler = compreg 'parrot'
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
    compiler.'import'('parrot', 'Elementary', 'targetns'=>ns)
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

.sub 'label' :method
    .param string label
    .local string func, cl
    .local pmc lsf, widget
    $P0 = getattribute self, 'class'
    cl = $P0
    widget = getattribute self, 'widget'
    func = concat 'elm_', cl
    func = concat func, '_label_set'
    lsf = get_hll_global ['Elementary'], func
    lsf(widget, label)
.end

.sub 'style' :method
    .param string style
    .local string func, cl
    .local pmc ssf, widget
    $P0 = getattribute self, 'class'
    cl = $P0
    widget = getattribute self, 'widget'
    func = concat 'elm_', cl
    func = concat func, '_style_set'
    ssf = get_hll_global ['Elementary'], func
    ssf(widget, style)
.end


.namespace ['Elementary';'win']

.sub 'new'
    .param pmc parent
    .param string name
    .param int type
    .local pmc win, cl, obj
    win = 'elm_win_add'(0, name, type)
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
    $I0 = isa obj, 'UnManagedStruct'
    if $I0 goto unmanaged
    obj = getattribute obj, 'widget'
  unmanaged:
    'elm_box_pack_end'(box,obj)
.end

.sub 'horizontal' :method
    .param int val
    .local pmc box
    box = getattribute self, 'widget'
    'elm_box_horizontal_set'(box, val)
.end

.sub 'homogenous' :method
    .param int val
    .local pmc box
    box = getattribute self, 'widget'
    'elm_box_homogenous_set'(box, val)
.end

.namespace ['Elementary';'bg']

.sub 'file_set' :method
    .param string file
    .param string group
    say "file_set NYI"
.end

.namespace ['Elementary';'frame']

.sub 'content' :method
    .param pmc obj
    .local pmc fr
    fr = getattribute self, 'widget'
    $I0 = isa obj, 'UnManagedStruct'
    if $I0 goto unmanaged
    obj = getattribute obj, 'widget'
  unmanaged:
    'elm_frame_content_set'(fr, obj)
.end

.namespace ['Elementary';'label']
.sub 'hax'
    say 'workaround...'
.end

.namespace ['Elementary';'button']
.sub 'icon'
    say 'NYI'
.end

# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:
