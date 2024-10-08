class MyScript < Thor
  check_unknown_options! :except => :with_optional

  def self.exit_on_failure?
    false
  end

  attr_accessor :some_attribute
  attr_writer :another_attribute
  attr_reader :another_attribute

  private
  attr_reader :private_attribute

  public
  group :script
  default_command :example_default_command

  map "-T" => :animal, ["-f", "--foo"] => :foo

  map "animal_prison" => "zoo"

  desc "zoo", "zoo around"
  def zoo
    true
  end

  desc "animal TYPE", "horse around"

  no_commands do
    no_commands do
      def this_is_not_a_command
      end
    end

    def neither_is_this
    end
  end

  def animal(type)
    [type]
  end

  map "hid" => "hidden"

  desc "hidden TYPE", "this is hidden", :hide => true
  def hidden(type)
    [type]
  end

  map "fu" => "zoo"

  desc "foo BAR", <<END
do some fooing
  This is more info!
  Everyone likes more info!
END
  method_option :force, :type => :boolean, :desc => "Force to do some fooing"
  def foo(bar)
    [bar, options]
  end

  method_option :all, :desc => "Do bazing for all the things"
  desc ["baz THING", "baz --all"], "super cool"
  def baz(thing = nil)
    raise if thing.nil? && !options.include?(:all)
  end

  desc "example_default_command", "example!"
  method_options :with => :string
  def example_default_command
    options.empty? ? "default command" : options
  end

  desc "call_myself_with_wrong_arity", "get the right error"
  def call_myself_with_wrong_arity
    call_myself_with_wrong_arity(4)
  end

  desc "call_unexistent_method", "Call unexistent method inside a command"
  def call_unexistent_method
    boom!
  end

  desc "long_description", "a" * 80
  long_desc <<-D
    This is a really really really long description.
    Here you go. So very long.

    It even has two paragraphs.
  D
  def long_description
  end

  desc "name-with-dashes", "Ensure normalization of command names"
  def name_with_dashes
  end

  desc "long_description", "a" * 80
  long_desc <<-D, wrap: false
No added indentation,   Inline
whatespace not merged,
Linebreaks preserved
  and
    indentation
  too
  D
  def long_description_unwrapped
  end

  method_options :all => :boolean
  method_option :lazy, :lazy_default => "yes"
  method_option :lazy_numeric, :type => :numeric, :lazy_default => 42
  method_option :lazy_array,   :type => :array,   :lazy_default => %w[eat at joes]
  method_option :lazy_hash,    :type => :hash,    :lazy_default => {'swedish' => 'meatballs'}
  desc "with_optional NAME", "invoke with optional name"
  def with_optional(name=nil, *args)
    [name, options, args]
  end

  class AnotherScript < Thor
    desc "baz", "do some bazing"
    def baz
    end
  end

  desc "send", "send as a command name"
  def send
    true
  end

  private

    def method_missing(meth, *args)
      if meth == :boom!
        super
      else
        [meth, args]
      end
    end

    desc "what", "what"
    def what
    end
end

class MyChildScript < MyScript
  remove_command :name_with_dashes

  method_options :force => :boolean, :param => :numeric
  def initialize(*args)
    super
  end

  desc "zoo", "zoo around"
  method_options :param => :required
  def zoo
    options
  end

  desc "animal TYPE", "horse around"
  def animal(type)
    [type, options]
  end
  method_option :other, :type => :string, :default => "method default", :for => :animal
  desc "animal KIND", "fish around", :for => :animal

  desc "boom", "explodes everything"
  def boom
  end

  remove_command :boom, :undefine => true
end

class Barn < Thor
  def self.exit_on_failure?
    false
  end

  desc "open [ITEM]", "open the barn door"
  def open(item = nil)
    if item == "shotgun"
      puts "That's going to leave a mark."
    else
      puts "Open sesame!"
    end
  end

  desc "paint [COLOR]", "paint the barn"
  method_option :coats, :type => :numeric, :default => 2, :desc => 'how many coats of paint'
  def paint(color='red')
    puts "#{options[:coats]} coats of #{color} paint"
  end
end

class PackageNameScript < Thor
  package_name "Baboon"
end

module Scripts
  class MyScript < MyChildScript
    argument :accessor, :type => :string
    class_options :force => :boolean
    method_option :new_option, :type => :string, :for => :example_default_command

    def zoo
      self.accessor
    end
  end

  class MyDefaults < Thor
    check_unknown_options!

    def self.exit_on_failure?
      false
    end

    namespace :default
    desc "cow", "prints 'moo'"
    def cow
      puts "moo"
    end

    desc "command_conflict", "only gets called when prepended with a colon"
    def command_conflict
      puts "command"
    end

    desc "barn", "commands to manage the barn"
    subcommand "barn", Barn
  end

  class ChildDefault < Thor
    namespace "default:child"
  end

  class Arities < Thor
    def self.exit_on_failure?
      false
    end

    desc "zero_args", "takes zero args"
    def zero_args
    end

    desc "one_arg ARG", "takes one arg"
    def one_arg(arg)
    end

    desc "two_args ARG1 ARG2", "takes two args"
    def two_args(arg1, arg2)
    end

    desc "optional_arg [ARG]", "takes an optional arg"
    def optional_arg(arg='default')
    end

    desc ["multiple_usages ARG --foo", "multiple_usages ARG --bar"], "takes mutually exclusive combinations of args and flags"
    def multiple_usages(arg)
    end
  end
end

class Apple < Thor
  namespace :fruits
  desc 'apple', 'apple'; def apple; end
  desc 'rotten-apple', 'rotten apple'; def rotten_apple; end
  map "ra" => :rotten_apple
end

class Pear < Thor
  namespace :fruits
  desc 'pear', 'pear'; def pear; end
end

class MyClassOptionScript < Thor
  class_option :free

  class_exclusive do
    class_option :one
    class_option :two
  end

  class_at_least_one do
    class_option :three
    class_option :four
  end

  desc "mix", ""
  exclusive do
    at_least_one do
      option :five
      option :six
      option :seven
    end
  end
  def mix
  end
end

class MyOptionScript < Thor
  desc "exclusive", ""
  exclusive do
    method_option :one
    method_option :two
    method_option :three
  end
  method_option :after1
  method_option :after2
  def exclusive
  end

  exclusive :after1, :after2, {:for => :exclusive}

  desc "at_least_one", ""
  at_least_one do
    method_option :one
    method_option :two
    method_option :three
  end
  method_option :after1
  method_option :after2
  def at_least_one
  end
  at_least_one :after1, :after2, :for => :at_least_one

  desc "only_one", ""
  exclusive do
    at_least_one do
      option :one
      option :two
      option :three
    end
  end
  def only_one
  end

  desc "no_relastions", ""
  option :no_rel1
  option :no_rel2
  def no_relations
  end
end
