requires 'perl', '5.8.9';
requires 'Moose';
requires 'Module::Build::Tiny';

on 'test' => sub {
    requires 'Test::More', '0.98';
};

