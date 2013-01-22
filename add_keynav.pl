#!/usr/bin/env perl

use common::sense;
use IO::File;

my $canon = <<'EOT';
<script src="jquery-1.4.2.js"></script>
<script src="jquery.hotkeys.js"></script>
<script type="text/javascript">
    $(document).bind('keyup', 'p', function(){window.location.href = "file:///Users/dstorrs/Dropbox/books/reference/SICP/<<PREV>>"});
    $(document).bind('keyup', 'n', function(){window.location.href = "file:///Users/dstorrs/Dropbox/books/reference/SICP/<<NEXT>>"});
</script>
</head>
EOT

use File::Slurp qw/slurp/;

for (@ARGV) {
	my $file = slurp $_;

	my ($next, $prev) = '';
	my $base = 'book-Z-H';
	say "----\nfile: $_";
	given ($_) {
		when ('book.html') {
			$next = "$base-1.html";
			$prev = "book.html";
		}
		when ('book-Z-H-38.html') {
			$prev = "book-37.html";
			$next = "book-38.html";
		}
		default {
			my ($num) = /${base}-(\d+)\.html/;
			say "num is: $num";
			$prev = $base . '-' . ($num - 1) . '.html';
			$next = $base . '-'. ($num + 1) . '.html';
		}
	}

	my $script = $canon;
	$script =~ s[<<PREV>>][$prev];
	$script =~ s[<<NEXT>>][$next];

	$file =~ s[</head>][$script];
	my $fh = IO::File->new(">$_") or say "oops, just whacked '$_'";
	print $fh $file;
}
