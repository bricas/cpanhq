#!/usr/bin/perl

use strict;
use warnings;

use XML::RSS;
use LWP::Simple qw(get);

my $content = get(
    'http://twitter.com/statuses/user_timeline/36758099.rss'
);

if (defined($content)) {

    my $tweets = XML::RSS->new();

    $tweets->parse( $content );

    open my $html_fh, ">>", "./root/static/tweets.html-portion";
    print {$html_fh} <<'EOF';
        <div id=sidebar>
<h2>CPANHQ Updates</h2>
<ul id=tweets>
EOF

    foreach my $tweet (@{$tweets->{'items'}})
    {
        my $desc = $tweet->{'description'};
        $desc =~ s{^cpanhq: }{};
        my $link = $tweet->{'link'};
        print {$html_fh} qq{<li>$desc <span class="link">(<a href="$link>link</a>)</span></li>\n};
    }

    print {$html_fh} <<'EOF';
</ul>
<p style="text-align: right;">Follow us on <a href="http://twitter.com/cpanhq">Twitter</a>.</p>
    </div>
EOF

    close($html_fh);
}

