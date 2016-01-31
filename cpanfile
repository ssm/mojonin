requires 'Mojolicious', '6.0';
requires 'Minion';
requires 'Contextual::Return';
requires 'Regexp::Grammars';

on 'test' => sub {
    requires 'Test::Class';
};

on 'develop' => sub {
    recommends 'Devel::NYTProf';
};
