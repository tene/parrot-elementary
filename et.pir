.sub 'win-del'
    .param pmc data
    .param pmc info
    say 'Goodbye...'
    'elm_exit'()
.end

.sub 'click-ok'
    .param pmc data
    .param pmc unused
    say ':D'
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
    .local pmc ewin, bg, box, fr, fr0, lb, box2
    $P0 = get_hll_global ['Elementary';'win'], 'new'
    ewin = $P0(0, "Hello", 0)
    .local pmc user_data
    user_data = new 'String'
    user_data = 'delete-request'
    .const 'Sub' cb = 'win-del'
    ewin.'add_callback'('delete-request', cb, user_data)

    bg = ewin.'widget_add'('bg', 1.0, 1.0)
    ewin.'resize_object_add'(bg)
    bg.'show'()

    box = ewin.'widget_add'('box', 1.0, 1.0)
    ewin.'resize_object_add'(box)
    box.'show'()

    fr = ewin.'widget_add'('frame', 1.0, 1.0)
    fr.'style'('pad_large')
    box.'pack_end'(fr)
    fr.'show'()

    lb = ewin.'widget_add'('label', 1.0, 1.0)
    lb.'label'("Hello, World!")
    fr.'content'(lb)
    lb.'show'()

    fr0 = ewin.'widget_add'('frame', 1.0, 1.0)
    fr0.'style'('outdent_bottom')
    box.'pack_end'(fr0)
    fr0.'show'()

    fr = ewin.'widget_add'('frame', 1.0, 1.0)
    fr.'style'('pad_medium')
    fr0.'content'(fr)
    fr.'show'()

    box2 = ewin.'widget_add'('box', 1.0, 1.0)
    box2.'horizontal'(1)
    box2.'homogenous'(1)
    fr.'content'(box2)
    box2.'show'()

    .local pmc bt
    bt = ewin.'widget_add'('button', 1.0, 1.0)
    bt.'label'("YA RLY")
    box2.'pack_end'(bt)
    bt.'show'()
    .const 'Sub' $P1 = 'click-ok'
    $P2 = new 'String'
    $P2 = "YA RLY"
    bt.'add_callback'('clicked', $P1, $P2)

    bt = ewin.'widget_add'('button', 1.0, 1.0)
    bt.'label'("NO WAI")
    box2.'pack_end'(bt)
    bt.'show'()
    .const 'Sub' $P1 = 'click-no'
    $P2 = new 'String'
    $P2 = "NO WAI"
    bt.'add_callback'('clicked', $P1, $P2)

    ewin.'show'()
    'elm_run'()
    'elm_shutdown'()
.end

# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:

