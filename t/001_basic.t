#!/usr/bin/perl

use strict;
use warnings;

use FindBin;
use File::Spec;
use CGI;

use Test::More tests => 7;

BEGIN {
    use_ok('CGI::Application::Plugin::Phrasebook');           
}

{
    package MyCGIApp;

    use strict;
    use warnings;
    
    use base 'CGI::Application';
    use CGI::Application::Plugin::Phrasebook;

    sub cgiapp_prerun {
        my $self = shift;
        $self->config_phrasebook(
            class  => 'Plain',
            loader => 'Text',
            file   => File::Spec->catdir($FindBin::Bin, 'my_phrasebook.txt'),        
        ); 
    }
    
    sub setup {
    	my $self = shift;
	    $self->start_mode('mode1');    	
    	$self->mode_param('mode');
    	$self->run_modes(
    	    'mode1' => 'some_run_mode',
            'mode2' => 'some_other_run_mode'    	    
    	);
    }

    sub some_run_mode {
        my $self = shift;
        return $self->phrasebook->fetch('greeting');
    }
    
    sub some_other_run_mode {
        my $self = shift;
        return $self->phrasebook->fetch('special_greeting', {
            name => $self->query->param('name')
        });
    }    
}

$ENV{CGI_APP_RETURN_ONLY} = 1;

{
	my $app = MyCGIApp->new();
	isa_ok($app, 'MyCGIApp');
	isa_ok($app, 'CGI::Application');

	$app->query(CGI->new({mode => 'mode1'}));
	my $output = $app->run();
	like($output, qr/Hello World/, '... got the right return value back');
}

{
	my $app = MyCGIApp->new();
	isa_ok($app, 'MyCGIApp');
	isa_ok($app, 'CGI::Application');

	$app->query(CGI->new({mode => 'mode2', name => 'Steve'}));
	my $output = $app->run();
	like($output, qr/Hello Steve/, '... got the right return value back');
}
