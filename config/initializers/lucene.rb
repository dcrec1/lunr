begin
  Dir[RAILS_ROOT + "/lib/*.jar"].each { |path| require path.split('/').last.gsub('.jar', '') }
  import org.apache.lucene.document.Field
  import org.apache.lucene.store.FSDirectory
  import org.apache.lucene.index.IndexWriter
  import org.apache.lucene.analysis.standard.StandardAnalyzer
  import org.apache.lucene.queryParser.standard.StandardQueryParser

  import org.apache.lucene.search.IndexSearcher
  import org.apache.lucene.search.BooleanClause
  import org.apache.lucene.search.BooleanQuery
  import org.apache.lucene.search.MatchAllDocsQuery
  import org.apache.lucene.search.WildcardQuery

  import org.apache.lucene.search.highlight.QueryScorer
  import org.apache.lucene.search.highlight.Highlighter

  import org.apache.lucene.util.Version
rescue Exception => e
  puts e
end
