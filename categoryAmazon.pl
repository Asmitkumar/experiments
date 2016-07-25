#!/usr/bin/perl
#use strict;
#use warnings;

use LWP::Simple;
use Data::Dumper;


#my @urls = ("http://www.amazon.in/s/ref=sr_abn_pp_ss_1389432031?ie=UTF8&bbn=1389432031&rh=n%3A1389432031");
#my @urls = ("http://www.amazon.in/s/ref=sr_abn_pp_ss_1389432031?ie=UTF8&bbn=1389432031&rh=n%3A1389432031")
my @contentUrls;


open FILE, "catUrlsAmazon" or die $!;
while(<FILE>)
{
   #print "$_";
   my $url = "$_";
   print STDERR "Crawling $url\n";
    my $content = get($url);
    #print STDERR Dumper \@urls;
    #my $content = `curl --silent '$url'`;
    #my $fields = extractFields($content);
    

    my $additionalUrls = extractUrls($content);
    push(@urls, @{$additionalUrls}) if defined $additionalUrls;
    #-- Randomly sleep between 1s and 5s
    sleep (int(rand(4)) + 1);
}

sub extractUrls {
    my ($content) = @_;
    my @urls;

    return if $content =~ /<\/h4>/;

    #-- Content URLs
    while ($content =~ /href="([^\"]+)">[^<]+<\/a><\/div><\/div><\/li><li id="[^\"]+" data\-asin/g) {
        my $url = $1;
        #$url = "http://www.amazon.in".$url;
        $url =~ s/#.*//;
        print STDERR "Found content url: $url\n";
        push(@contentUrls, $url);
        open(FH, '>>', 'allAmazonContentUrls3.txt') or die "cannot open file";
                select FH;
                print $url."\n";
    }

    while ($content =~ /<a class=\"a-link-normal\s*a\-text\-normal\"\s*href\=\"([^\"]+)\"/g){
        my $url2 = $1;
        #$url = "http://www.amazon.in".$url;
        $url2 =~ s/#.*//;
        print STDERR "Found content url2: $url2\n";
        push(@contentUrls, $url);
        open(FH, '>>', 'allAmazonContentUrls2.txt') or die "cannot open file";
                select FH;
                print $url2."\n"; 
       
    }
}



#my $i;
#    while ($i <= 400){
#        #print $i;
#        my $url2 = "http://www.amazon.in/Smartphones-Basic-Mobiles-Accessories/s?ie=UTF8&page="."$i"."&rh=n%3A1389432031";
#        print $url2."\n";
#        $i++;
#    }

