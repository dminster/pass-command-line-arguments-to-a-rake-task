options and dependencies need to be inside arrays:

namespace :thing do
  desc "it does a thing"
  task :work, [:option, :foo, :bar] do |task, args|
    puts "work", args
  end

  task :another, [:option, :foo, :bar] do |task, args|
    puts "another #{args}"
    Rake::Task["thing:work"].invoke(args[:option], args[:foo], args[:bar])
    # or splat the args
    # Rake::Task["thing:work"].invoke(*args)
  end

end
Then

rake thing:work[1,2,3]
=> work: {:option=>"1", :foo=>"2", :bar=>"3"}

rake thing:another[1,2,3]
=> another {:option=>"1", :foo=>"2", :bar=>"3"}
=> work: {:option=>"1", :foo=>"2", :bar=>"3"}
NOTE: variable task is the the task object, not very helpful unless you know/care about Rake internals.

RAILS NOTE:

If running the task from rails, its best to preload the environment by adding => [:environment] which is a way to setup dependent tasks.

  task :work, [:option, :foo, :bar] => [:environment] do |task, args|
    puts "work", args
  end
