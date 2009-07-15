use Elementary:from<parrot>;
elm_init(@*ARGV, $*PROGRAM_NAME);
my $win = Elementary::win::new(0, "Hello", 0);
$win.add_callback('delete-request', -> $data, $info { say 'Goodbye…'; elm_exit() }, "deleted");
my $bg = $win.widget_add('bg', 1.0, 1.0);
$win.resize_object_add($bg);
$bg.show();
my $box = $win.widget_add('box', 1.0, 1.0);
$win.resize_object_add($box);
$box.show();
my $fr = $win.widget_add('frame', 1.0, 1.0);
$fr.style('pad_large');
$box.pack_end($fr);
$fr.show();
my $lb = $win.widget_add('label', 1.0, 1.0);
$lb.label("Hello, World!");
$fr.content($lb);
$lb.show();
my $fr2 = $win.widget_add('frame', 1.0, 1.0);
$fr2.style('outdent_bottom');
$box.pack_end($fr2);
$fr2.show();
$fr = $win.widget_add('frame', 1.0, 1.0);
$fr.style('pad_medium');
$fr2.content($fr);
$fr.show;
my $box2 = $win.widget_add('box', 1.0, 1.0);
$box2.horizontal(1);
$box2.homogenous(1);
$fr.content($box2);
$box2.show;
my $bt = $win.widget_add('button', 1.0, 1.0);
$bt.label("YA RLY");
$box2.pack_end($bt);
$bt.show;
$bt.add_callback('clicked', -> $data, $info { say 'lol hai!' }, "hai");
$bt = $win.widget_add('button', 1.0, 1.0);
$bt.label("NO WAI");
$box2.pack_end($bt);
$bt.show;
$bt.add_callback('clicked', -> $data, $info { say ':( :( :(' }, "wtf");
$win.show();
elm_run();
elm_shutdown();
