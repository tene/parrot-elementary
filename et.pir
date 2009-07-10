.sub 'win-del'
    .param pmc data
    .param pmc info
    say 'Goodbye...'
    'elm_exit'()
.end

.sub 'click-ok'
    .param pmc data
    .param pmc unused
    say 'YES!!!'
.end

.sub 'click-no'
    .param pmc data
    .param pmc unused
    say ':('
.end

.sub main :main
    .param pmc argv
    load_bytecode 'NCI/call_toolkit_init.pbc'
    .local pmc c, cti, ech
    load_language 'parrot'
    c = compreg 'parrot'
    c.'import'('Elementary')
    cti = get_root_global ['parrot';'NCI'], 'call_toolkit_init'
    .local pmc elm_init
    elm_init = get_global 'elm_init'
    argv = cti(elm_init, argv)
    .local pmc win, bg, box, fr, fr0, lb, box2
    win = 'elm_win_add'(0,"hello",0)
    'elm_win_title_set'(win, "Hello")
    $P2 = new 'String'
    $P2 = 'delete-request'
    .local pmc cb, mech
    $P0 = loadlib 'evas_cb_helper'
    if $P0 goto has_helper_lib
    say 'oh noes'
    exit 1
    has_helper_lib:
    .const 'Sub' $P1 = 'win-del'
    mech = dlfunc $P0, 'make_evas_cb_helper', 'PJPPS'
    cb = mech($P1, $P2, 'vUpp')
    'evas_object_smart_callback_add'(win, 'delete-request', cb, $P2)

    bg = 'elm_bg_add'(win)
    'evas_object_size_hint_weight_set'(bg,1.0,1.0)
    'elm_win_resize_object_add'(win,bg)
    'evas_object_show'(bg)

    box = 'elm_box_add'(win)
    'evas_object_size_hint_weight_set'(box,1.0,1.0)
    'elm_win_resize_object_add'(win,box)
    'evas_object_show'(box)

    fr = 'elm_frame_add'(win)
    'elm_frame_style_set'(fr,'pad_large')
    'evas_object_size_hint_weight_set'(fr,1.0,1.0)
    'elm_box_pack_end'(box,fr)
    'evas_object_show'(fr)

    lb = 'elm_label_add'(win)
    'elm_label_label_set'(lb, "Hello, World!")
    'elm_frame_content_set'(fr, lb)
    'evas_object_show'(lb)

    fr0 = 'elm_frame_add'(win)
    'elm_frame_style_set'(fr0, 'outdent_bottom')
    'evas_object_size_hint_weight_set'(fr0,1.0,1.0)
    'elm_box_pack_end'(box, fr0)
    'evas_object_show'(fr0)

    fr = 'elm_frame_add'(win)
    'elm_frame_style_set'(fr, 'pad_medium')
    'elm_frame_content_set'(fr0, fr)
    'evas_object_show'(fr)

    box2 = 'elm_box_add'(win)
    'elm_box_horizontal_set'(box2, 1)
    'elm_box_homogenous_set'(box2, 1)
    'elm_frame_content_set'(fr, box2)
    'evas_object_show'(box2)

    .local pmc bt
    bt = 'elm_button_add'(win)
    'elm_button_label_set'(bt, "YA RLY")
    'evas_object_size_hint_weight_set'(bt,1.0,1.0)
    'elm_box_pack_end'(box2, bt)
    'evas_object_show'(bt)
    .const 'Sub' $P1 = 'click-ok'
    $P2 = new 'String'
    $P2 = "YA RLY"
    cb = mech($P1, $P2, 'vUpp')
    'evas_object_smart_callback_add'(bt, 'clicked', cb, $P2)

    bt = 'elm_button_add'(win)
    'elm_button_label_set'(bt, "NO WAI")
    'evas_object_size_hint_weight_set'(bt,1.0,1.0)
    'elm_box_pack_end'(box2, bt)
    'evas_object_show'(bt)
    .const 'Sub' $P1 = 'click-no'
    $P2 = new 'String'
    $P2 = "NO WAI"
    cb = mech($P1, $P2, 'vUpp')
    'evas_object_smart_callback_add'(bt, 'clicked', cb, $P2)

    'evas_object_show'(win)
    'elm_run'()
    'elm_shutdown'()
.end

# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:

