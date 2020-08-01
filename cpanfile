requires 'perl', '5.014004';
requires 'Moose';

on 'test' => sub {
    requires 'Test::More', '0.98';
};

on 'configure' => sub{
    requires 'Module::Build::Tiny', '0.035';
}
