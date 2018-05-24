use strict;
use warnings;

use Cwd;
use File::Basename;

my $include_expression = "#include\\s*[<\"]([^>\"]+)[>\"]";

my @include_paths_qt5 = ("./"
                        ,"/usr/include/qt/"
                        ,"/usr/incldue/qt/QtCore/"
                        ,"/usr/include/qt/QtGui/"
                        ,"/usr/include/qt/QtWidgets/"
                        ,"/usr/include/qt/QtPrintSupport/"
                        ,"/usr/include/qt/QtSvg"
                        ,"/usr/include/qt/QtDBus/"
                        ,"/usr/include/qt/QtSql/"
                        ,"/usr/include/qt/QtXml/");

my @include_paths_qt4 = ("./"
                        ,"/usr/include/qt4/"
                        ,"/usr/include/qt4/Qt/"
                        ,"/usr/include/qt4/QtCore/"
                        ,"/usr/include/qt4/QtGui/"
                        ,"/usr/include/qt4/QtSvg/"
                        ,"/usr/include/qt4/QtDBus/"
                        ,"/usr/include/qt4/QtSql/"
                        ,"/usr/include/qt4/QtXml/");

my @include_paths = @include_paths_qt5;

sub list_indirect_includes
{
    my $includes = shift;

    my $file_name = shift;
    my $file_path;
    my $file;

    my $recurse = shift;

    foreach my $include_path (@include_paths)
    {
        $file_path = $include_path . $file_name;

        if(-r $file_path)
        {          
            open($file, "<", $file_path) or die "Can't open \"${file_name}\": $!";
        }
    }

    return unless(defined $file);

    while(<$file>)
    {
        if(/$include_expression/)
        {
            my $include = $1;

            unless(defined $includes->{$include})
            {
                $includes->{$include} = 1;
                
                if($recurse)
                {
                    list_indirect_includes($includes, $include, $recurse);
                }
            }
        }
    }
};

sub unmask_include
{
    my $masked_includes = shift;
    my $include = shift;

    my $masking_include = $masked_includes->{$include};

    if(defined $masking_include)
    {
        return "\"${masking_include}\" (masking \"${include}\")";
    }
    else
    {
        return "\"${include}\"";
    }
};

sub print_redundant_includes
{
    my $file_name = shift;

    my $indirect_includes = shift;
    my $masked_includes = shift;

    foreach my $include1 (keys %{$indirect_includes})
    {
        foreach my $include2 (keys %{$indirect_includes})
        {
            if($include1 ne $include2 && defined $indirect_includes->{$include2}->{$include1})
            {
                my $displayed_include1 = unmask_include($masked_includes, $include1);
                my $displayed_include2 = unmask_include($masked_includes, $include2);

                print STDERR "In file \"${file_name}\", include ${displayed_include1} is redundant with ${displayed_include2}.\n";
            }
        }
    }

    print STDERR "\n";
};

foreach my $file_name (@ARGV)
{
    my %all_indirect_includes = ();
    my %all_masked_includes = ();

    my $working_directory = cwd();
    chdir(dirname($file_name));

    open(my $file, "<", $file_name) or die "Can't open \"${file_name}\": $!";

    while(<$file>)
    {
        if(/$include_expression/)
        {
            print STDOUT "In file \"${file_name}\", listing indirect includes of \"$1\"...\n";

            my $direct_include = $1;
            my $indirect_includes = {};

            # includes beginning with capital letter 'Q'
            # are assumed to be Qt's per-class or per-module header
            # which mask other Qt header
            if($direct_include =~ /^Q.*$/)
            {
                list_indirect_includes($indirect_includes, $direct_include, 0);

                foreach my $indirect_include (keys %{$indirect_includes})
                {
                    my $more_indirect_includes = {};

                    list_indirect_includes($more_indirect_includes, $indirect_include, 1);

                    $all_indirect_includes{$indirect_include} = $more_indirect_includes;
                    $all_masked_includes{$indirect_include} = $direct_include;
                }
            }
            else
            {
                list_indirect_includes($indirect_includes, $direct_include, 1);

                $all_indirect_includes{$direct_include} = $indirect_includes;
            }
        }
    }

    print STDOUT "\n";
    
    print_redundant_includes($file_name, \%all_indirect_includes, \%all_masked_includes);

    chdir($working_directory);
}
