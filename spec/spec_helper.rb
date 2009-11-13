# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path(File.join(File.dirname(__FILE__),'..','config','environment'))
require 'spec/autorun'
require 'spec/rails'

# Uncomment the next line to use webrat's matchers
#require 'webrat/integrations/rspec-rails'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir[File.expand_path(File.join(File.dirname(__FILE__),'support','**','*.rb'))].each {|f| require f}

Spec::Runner.configure do |config|
end

require File.expand_path(File.dirname(__FILE__) + '/resource_helper')

def directory
  file = java.io.File.new Document::PATH
  org.apache.lucene.store.FSDirectory.open file
end

def get_writer
  analizer = org.apache.lucene.analysis.SimpleAnalyzer.new
  writer = org.apache.lucene.index.IndexWriter
  writer.new directory, analizer, true, writer::MaxFieldLength::UNLIMITED
end

def get_field(name, value)
  field = org.apache.lucene.document.Field
  field.new name, value, field::Store::YES, field::Index::ANALYZED
end

def search(params)
  searcher = org.apache.lucene.search.IndexSearcher.new directory, true
  term = org.apache.lucene.index.Term.new params.keys.first.to_s, params.values.first
  query = org.apache.lucene.search.TermQuery.new(term)
  searcher.search(query, nil, 10).scoreDocs.map do |score_doc|
    searcher.doc score_doc.doc
  end
end

def save(attributes)
  writer = get_writer
  document = org.apache.lucene.document.Document.new
  attributes.stringify_keys.each do |key, value|
    document.add get_field(key, value)
  end
  writer.add_document document
  writer.close
end
