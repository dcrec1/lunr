shared_examples_for "local setup" do
  before :each do
    stub_tasks
  end

  it "should run migrations" do
    subject.environment = "env1"
    expect_command "rake db:migrate RAILS_ENV=#{subject.environment}"
    subject.local_setup
  end

  it "should run migration after installing gems" do
    expect_command("rake gems:install RAILS_ENV=#{subject.environment}").ordered
    expect_command("rake db:migrate RAILS_ENV=#{subject.environment}").ordered
    subject.local_setup
  end

  it "should run init.sh if exists" do
    file_exists "init.sh"
    expect_command "./init.sh"
    subject.local_setup
  end

  it "should run init.sh if doesnt exists" do
    file_doesnt_exists "init.sh"
    dont_accept_command "./init.sh"
    subject.local_setup
  end

  it "should ensure folder tmp/pids exists" do
    expect_command "mkdir -p tmp/pids"
    subject.local_setup
  end

  it "should ensure folder db exists" do
    expect_command "mkdir -p db"
    subject.local_setup
  end

  it "should copy config/*.sample to config/*" do
    path_exists "config"
    file_exists "config/database.yml.sample"
    subject.local_setup
    File.exists?("config/database.yml").should be_true
  end

  it "should not copy config/*.sample to config/* if destination file exists" do
    content = "asfasfasfe"
    path_exists "config"
    file_exists "config/database.yml", :content => content
    file_exists "config/database.yml.sample"
    subject.local_setup
    File.open("config/database.yml").read.should eql(content)
  end

  it "should install gems" do
    subject.environment = "en3"
    expect_command "rake gems:install RAILS_ENV=#{subject.environment}"
    subject.local_setup
  end

  it "should copy config/*.sample files before installing gems" do
    file_exists "config/gems.yml.sample"
    subject.stub!(:install_gems).and_raise(Exception.new)
    begin
      subject.local_setup
    rescue Exception
      File.exists?("config/gems.yml").should be_true
    end
  end

  it "should package the assets if asset_packager exists" do
    subject.stub!(:tasks).and_return("rake acceptance rake asset:packager:build_all rake asset:packager:create_yml")
    expect_command "rake asset:packager:build_all"
    subject.local_setup
  end

  it "should parse less files if more exists" do
    subject.stub!(:tasks).and_return("rake acceptance rake more:parse rake asset:packager:create_yml")
    expect_command "rake more:parse"
    subject.local_setup
  end

  it "should not parse less files if more doesnt exist" do
    dont_accept_command "rake more:parse"
    subject.local_setup
  end

  it "should parse less files before package assets" do
    subject.stub!(:tasks).and_return("rake more:parse rake asset:packager:build_all")
    expect_command("rake more:parse").ordered
    expect_command("rake asset:packager:build_all").ordered
    subject.local_setup
  end
end

shared_examples_for "remote update" do
  before :each do
    @path = subject.path
  end

  it "should run inploy:local:update task in the server" do
    subject.environment = "env10"
    expect_command "ssh #{@ssh_opts} #{@user}@#{@host} 'cd #{@path}/#{@application} && rake inploy:local:update environment=#{subject.environment}'"
    subject.remote_update
  end
end

shared_examples_for "local update" do
  before :each do
    stub_tasks
  end

  it "should init submodules" do
    expect_command "git submodule update --init"
    subject.local_update
  end

  it "should run the migrations for the environment" do
    expect_command "rake db:migrate RAILS_ENV=#{subject.environment}"
    subject.local_update
  end

  it "should restart the server" do
    expect_command "touch tmp/restart.txt"
    subject.local_update
  end

  it "should clean the public cache" do
    expect_command "rm -R -f public/cache"
    subject.local_update
  end

  it "should not package the assets if asset_packager exists" do
    dont_accept_command "rake asset:packager:build_all"
    subject.local_update
  end

  it "should package the assets if asset_packager exists" do
    subject.stub!(:tasks).and_return("rake acceptance rake asset:packager:build_all rake asset:packager:create_yml")
    expect_command "rake asset:packager:build_all"
    subject.local_update
  end

  it "should install gems" do
    subject.environment = "env6"
    expect_command "rake gems:install RAILS_ENV=#{subject.environment}"
    subject.local_update
  end

  it "should parse less files if more exists" do
    subject.stub!(:tasks).and_return("rake acceptance rake more:parse rake asset:packager:create_yml")
    expect_command "rake more:parse"
    subject.local_update
  end

  it "should not parse less files if more doesnt exist" do
    dont_accept_command "rake more:parse"
    subject.local_update
  end

  it "should parse less files before package assets" do
    subject.stub!(:tasks).and_return("rake more:parse rake asset:packager:build_all")
    expect_command("rake more:parse").ordered
    expect_command("rake asset:packager:build_all").ordered
    subject.local_update
  end

  it "should copy config/*.sample to config/*" do
    path_exists "config"
    file_exists "config/hosts.yml.sample"
    subject.local_update
    File.exists?("config/hosts.yml").should be_true
  end

  it "should notify hoptoad" do
    subject.environment = "env8"
    expect_command("rake hoptoad:deploy TO=#{subject.environment} REPO=#{subject.repository} REVISION=#{`git log | head -1 | cut -d ' ' -f 2`}").ordered
    subject.local_update
  end
end
