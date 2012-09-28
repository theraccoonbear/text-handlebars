package Text::Handlebars::Compiler;
use Any::Moose;

extends 'Text::Xslate::Compiler';

has '+syntax' => (
    default => 'Handlebars',
);

sub _generate_block {
    my $self = shift;
    my ($node) = @_;

    return (
        $self->_localize_vars($node->first),
        (map { $self->compile_ast($_) } @{ $node->second }),
    );
}

if (0) {
    our $_recursing;
    around compile_ast => sub {
        my $orig = shift;
        my $self = shift;

        my @ast = do {
            local $_recursing = 1;
            $self->$orig(@_);
        };
        use Data::Dump; ddx(\@ast) unless $_recursing;
        return @ast;
    };
}

__PACKAGE__->meta->make_immutable;
no Any::Moose;

1;
