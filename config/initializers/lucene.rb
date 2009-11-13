begin
  Dir[RAILS_ROOT + "/lib/*.jar"].each { |path| require path.split('/').last.gsub('.jar', '') }
  import org.apache.lucene.document.Field
  import org.apache.lucene.store.FSDirectory
  import org.apache.lucene.search.IndexSearcher
  import org.apache.lucene.index.IndexWriter
  import org.apache.lucene.analysis.SimpleAnalyzer
  import org.apache.lucene.index.Term
  import org.apache.lucene.search.TermQuery
  system "mkdir -p #{Document::PATH}"
rescue Exception => e
  puts e
end
