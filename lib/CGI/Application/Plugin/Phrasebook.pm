
package CGI::Application::Plugin::Phrasebook;

use strict;
use warnings;

use Carp         'confess';
use Scalar::Util 'blessed';

use CGI::Application;
use Data::Phrasebook;

our $VERSION = '0.01';

our @EXPORT = qw(
    config_phrasebook
    phrasebook
);

sub import {
    my $pkg  = shift;
    my $call = caller;
    no strict 'refs';
    foreach my $sym (@EXPORT) {
        *{"${call}::$sym"} = \&{$sym};
    }
}

sub config_phrasebook {
    my $self = shift;
    $self->{'__PHRASEBOOK'}{'pb'} = Data::Phrasebook->new(@_);
}

sub phrasebook {
    my $self = shift;
    return $self->{'__PHRASEBOOK'}{'pb'};
}

1;

__END__

=pod

=head1 NAME

CGI::Application::Plugin::Phrasebook - A CGI::Application plugin for Data::Phrasebook

=head1 SYNOPSIS
  
  package MyCGIApp;
  
  use base 'CGI::Application';
  use CGI::Application::Plugin::Phrasebook;
  
  sub cgiapp_prerun {
      my $self = shift;
      $self->config_phrasebook(
          class  => 'Plain',
          loader => 'YAML',
          file   => 'conf/my_phrasebook.yml',        
      ); 
      # ... do other stuff here ...
  }
  
  sub some_run_mode {
      my $self = shift;
      # grab the phrasebook instance 
      # and fetch a keyword from it
      return $self->phrasebook->fetch('a_phrasebook_keyword');
  }

=head1 DESCRIPTION

This is a very simple plugin which provides access to an instance of 
L<Data::Phrasebook> inside your L<CGI::Application>. I could have 
just stuffed this in with C<param>, but this way is much nicer (and 
easier to type).

=head1 METHODS

=over 4

=item B<config_phrasebook (@phrasebook_args)>

This configures your L<Data::Phrasebook> instance by simply passing 
any arguments onto C<Data::Phrasebook::new>. It then stashes it into 
the L<CGI::Application> instance.

=item B<phrasebook>

This will return the L<Data::Phrasebook> instance, or undef if one 
has not yet been configured.

=back

=head1 SEE ALSO

=over 4

=item L<Data::Phrasebook>

=item L<http://www.perl.com/pub/a/2002/10/22/phrasebook.html>

=back

=head1 BUGS

All complex software has bugs lurking in it, and this module is no 
exception. If you find a bug please either email me, or add the bug
to cpan-RT.

=head1 AUTHOR

Stevan Little E<lt>stevan@iinteractive.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2006 by Infinity Interactive, Inc.

L<http://www.iinteractive.com>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. 

=cut