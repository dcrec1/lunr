begin
  Dir[RAILS_ROOT + "/lib/*.jar"].each { |path| require path.split('/').last.gsub('.jar', '') }
  import org.apache.lucene.document.Field
  import org.apache.lucene.store.FSDirectory
  import org.apache.lucene.search.IndexSearcher
  import org.apache.lucene.index.IndexWriter
  import org.apache.lucene.analysis.standard.StandardAnalyzer
  import org.apache.lucene.search.WildcardQuery
rescue Exception => e
  puts e
end
