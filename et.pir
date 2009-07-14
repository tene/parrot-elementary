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
    .local pmc c, ech
    load_language 'parrot'
    c = compreg 'parrot'
    c.'import'('Elementary')
    argv = 'elm_init'(argv)
    .local pmc ewin, win, bg, box, fr, fr0, lb, box2
    $P0 = get_hll_global ['Elementary';'Window'], 'new'
    ewin = $P0(0, "Hello", 0)
    .local pmc user_data
    user_data = new 'String'
    user_data = 'delete-request'
    .const 'Sub' cb = 'win-del'
    ewin.'add_callback'('delete-request', cb, user_data)
    win = getattribute ewin, 'widget'

    bg = ewin.'widget_add'('bg', 1.0, 1.0)
    ewin.'resize_object_add'(bg)
    'evas_object_show'(bg)

    box = ewin.'widget_add'('box', 1.0, 1.0)
    ewin.'resize_object_add'(box)
    'evas_object_show'(box)

    fr = ewin.'widget_add'('frame', 1.0, 1.0)
    'elm_frame_style_set'(fr,'pad_large')
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
    .const 'Sub' cb2 = 'click-ok'
    user_data = new 'String'
    user_data = "YA RLY"
    ewin.'add_callback'('clicked', cb2, user_data)

    bt = 'elm_button_add'(win)
    'elm_button_label_set'(bt, "NO WAI")
    'evas_object_size_hint_weight_set'(bt,1.0,1.0)
    'elm_box_pack_end'(box2, bt)
    'evas_object_show'(bt)
    .const 'Sub' $P1 = 'click-no'
    $P2 = new 'String'
    $P2 = "NO WAI"
    cb = 'make_evas_cb_helper'($P1, $P2, 'vUpp')
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

