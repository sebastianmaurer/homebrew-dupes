require 'formula'

class Ab < Formula
  homepage 'http://httpd.apache.org/docs/trunk/programs/ab.html'
  url 'http://archive.apache.org/dist/httpd/httpd-2.4.3.tar.bz2'
  sha256 '0ef1281bb758add937efe61c345287be2f27f662'

  depends_on 'libtool'

  def patches
      { :p1 => DATA } # Disable requirement for PCRE ("ab" does not need that)
  end

  def install
    # Mountain Lion requires this to be set, as otherwise libtool complains
    # about being "unable to infer tagged configuration"
    ENV['LTFLAGS'] = '--tag CC'
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"

    cd 'support' do
        system 'make', 'ab'
        # We install into the "bin" directory, although "ab" would normally be
        # installed to "/usr/sbin/ab"
        bin.install('ab')
    end
    man1.install('docs/man/ab.1')
  end

  def test
    print `"#{bin}/ab" -k -n 10 -c 10 http://www.apple.com/`
  end
end

__END__
diff --git a/configure b/configure
index 5f4c09f..84d3de2 100755
--- a/configure
+++ b/configure
@@ -6130,8 +6130,6 @@ $as_echo "$as_me: Using external PCRE library from $PCRE_CONFIG" >&6;}
     done
   fi
 
-else
-  as_fn_error $? "pcre-config for libpcre not found. PCRE is required and available from http://pcre.org/" "$LINENO" 5
 fi
 
   APACHE_VAR_SUBST="$APACHE_VAR_SUBST PCRE_LIBS"
