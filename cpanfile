requires 'perl', '5.008008';
requires 'Moose';
requires 'Module::Build::Tiny';

on 'test' => sub {
    requires 'Test::More', '0.98';
};

