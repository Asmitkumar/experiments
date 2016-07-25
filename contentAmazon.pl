	#!/usr/bin/perl
	#use strict;
	#use warnings;

	use LWP::Simple;
	use Data::Dumper;
        use JSON::XS;

	#my @urls = ("http://www.amazon.in/s/ref=sr_abn_pp_ss_1389432031?ie=UTF8&bbn=1389432031&rh=n%3A1389432031");

	my @urls = ("http://www.amazon.in/Moto-Plus-4th-Gen-Black/dp/B01DDP7GZK");

	#print "Here";
	#foreach my $url (@urls) {
         open FILE, "allUrls.txt" or die $!;
        while(<FILE>)
         {
            my $url = "$_";
	    print STDERR "Crawling $url\n";
	    my $content = get($url);
	    my $fields = extractFields($content, $url);

	    #-- Randomly sleep between 1s and 5s
	    sleep (int(rand(4)) + 1);
	}

	sub extractFields {
	    my ($content, $url) = @_;
	    
	    return if $content !~ /i/;
	    my $data;
	    my @features_array;

	    #-- Extract name
	    if ($content =~ /<span id="productTitle"[^>]*>\s*([^<]+<\/span>)/) {
	        my $name = $1;
	        $name =~ s/\s*<\/span>//sig;
	        if ($name){
	        $data->{name} = $name;
	    }
	    else{
	    	$data->{name} = "Name not present";
	    }
	}
	     
	    
	    #-- Extract Features
	        while ($content =~ /<td class=\"label\"[^>]*>\s*([^<+]\s*[^<]+<\/td>\s*<td\s*class\=\s*\"value\">[^<]+)/g) {
	            my $line = $1;
	            $line =~ s/<\/td>//sig;
	            $line =~ s/<td class="value">/\:/sig;
	            $line =~ s/Best Sellers Rank:.*//sig;
	            #print $line;
	            #print STDERR Dumper $line;
	            if ($line){
	            push (@features_array, $line);
	        }
		    #-- Extract features present in a different part of the page
	        }
	        while ($content =~ /<li><span class=\"a-list-item\">\s*([^<]+)<\/span>\s*<\/li>/g) {
	            my $line2 = $1;
	            $line2 =~ s/<\/td>//sig;
	            $line2 =~ s/<td class="value">/\:/sig;
	            $line2 =~ s/Best Sellers Rank:.*//sig;
	            #print $line;
	            #print STDERR Dumper $line;
	            if ($line2){
	            push (@features_array, $line2);
	        }
	        }
	        if (@features_array){
	        $data->{feature} = \@features_array;
	    }
	    else{
	    	$data->{feature} = "Features Not present";
	    }

	  #  #-- Extract price
	    if ($content =~ /<span id="priceblock\_ourprice"[^>]+><span[^>]+>[^<]+<\/span>([^<]+)<\/span>/) {
	        $data->{price} = $1;
	    }
            chomp($url);
	    if ($url){
            $data->{url} = $url;
	        }
	    #print STDERR Dumper $data;
            my $json = encode_json $data;
            print STDERR $json;
open(FH, '>>', 'allAmazonContent.json') or die "cannot open file";
                select FH;
                print $json."\n"; 
	    }
	#}




