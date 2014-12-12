module Pippi::Checks

  module MyModule
    def strip(*args, &blk)
      result = super
      if self.class._pippi_method_call_sequences
        self.class._pippi_method_call_sequences.methods_to_track.each do |track_this|
          result.define_singleton_method(track_this, track_it_proc(track_this))
        end
      end
      result
    end

    def track_it_proc(method_name)
      location = caller_locations.find { |c| c.to_s !~ /byebug|lib\/pippi\/checks/ }
      proc do |*args, &blk|
        begin
          self.class._pippi_method_call_sequences.found_sequence(method_name, location)
        rescue NameError
          return super(*args, &blk)
        else
          return super(*args, &blk)
        end
      end
    end

  end

  class MethodSequenceFinder < Check

    STRING_METHODS_TO_TRACK = [:ascii_only?, :b, :between?, :bytes, :bytesize, :byteslice, :capitalize, :capitalize!, :casecmp, :center, :chars, :chomp, :chomp!, :chop, :chop!, :chr, :clear, :codepoints, :concat, :count, :crypt, :delete, :delete!, :downcase, :downcase!, :dump, :each_byte, :each_char, :each_codepoint, :each_line, :empty?, :encode, :encode!, :encoding, :end_with?, :force_encoding, :getbyte, :gsub, :gsub!, :hex, :index, :insert, :intern, :length, :lines, :ljust, :lstrip, :lstrip!, :match, :next, :next!, :oct, :ord, :partition, :replace, :reverse, :reverse!, :rindex, :rjust, :rpartition, :rstrip, :rstrip!, :scan, :scrub, :scrub!, :setbyte, :size, :slice, :slice!, :split, :squeeze, :squeeze!, :start_with?, :strip, :strip!, :sub, :sub!, :succ, :succ!, :sum, :swapcase, :swapcase!, :to_c, :to_f, :to_i, :to_r, :to_str, :to_sym, :tr, :tr!, :tr_s, :tr_s!, :unpack, :upcase, :upcase!, :upto, :valid_encoding?]

    ARRAY_METHODS_TO_TRACK = [:all?, :any?, :assoc, :at, :bsearch, :chunk, :clear, :collect, :collect!, :collect_concat, :combination, :compact, :compact!, :concat, :count, :cycle, :delete, :delete_at, :delete_if, :detect, :drop, :drop_while, :each, :each_cons, :each_entry, :each_index, :each_slice, :each_with_index, :each_with_object, :empty?, :entries, :fetch, :fill, :find, :find_all, :find_index, :first, :flat_map, :flatten, :flatten!, :grep, :group_by, :histogram, :index, :inject, :insert, :join, :keep_if, :last, :lazy, :length, :map, :map!, :max, :max_by, :member?, :min, :min_by, :minmax, :minmax_by, :none?, :one?, :pack, :partition, :permutation, :pop, :product, :push, :rassoc, :reduce, :reject, :reject!, :repeated_combination, :repeated_permutation, :replace, :reverse, :reverse!, :reverse_each, :rindex, :rotate, :rotate!, :sample, :select, :select!, :shift, :shuffle, :shuffle!, :size, :slice, :slice!, :slice_before, :sort, :sort!, :sort_by, :sort_by!, :take, :take_while, :to_a, :to_ary, :to_h, :transpose, :uniq, :uniq!, :unshift, :values_at, :zip]

    class Record
      attr_reader :path, :lineno, :meth1, :meth2
      def initialize(path, lineno, meth1, meth2)
        @path = path
        @lineno = lineno
        @meth1 = meth1
        @meth2 = meth2
      end
      def eql?(other)
        path == other.path && lineno == other.lineno && meth1 == other.meth1 && meth2 == other.meth2
      end
      def hash
        require 'zlib'
        Zlib.crc32("#{path}:#{lineno}:#{meth1}:#{meth2}")
      end
    end

    attr_reader :sequences, :clazz_to_decorate, :starting_method

=begin
To add a new sequence finder where the first method is on String, change the starting_method below
and also change the method name up in MyModule.  To change it to a different class you must also
change :clazz_to_decorate

=end
    def initialize(ctx)
      super
      @clazz_to_decorate = String
      @starting_method = "strip"

      @sequences = Set.new
    end

    def methods_to_track
      if clazz_to_decorate == String
        STRING_METHODS_TO_TRACK
      elsif clazz_to_decorate == Array
        ARRAY_METHODS_TO_TRACK
      else
        raise "Unhandled class #{clazz_to_decorate}"
      end
    end

    def dump
      @sequences.map {|r| "#{r.meth1}:#{r.meth2}" }.inject({}) {|m,i| m[i] ||= 0 ;  m[i] += 1  ; m }.to_a.sort_by {|x| x[1] }.reverse.each do |r|
        puts "#{r[0].split(':')[0]} followed by #{r[0].split(':')[1]} occurred #{r[1]} times\n"
        @sequences.select {|s| (s.meth1 == r[0].split(':')[0]) && (s.meth2 == r[0].split(':')[1].to_sym) }.each do |s|
          puts "#{s.path}: #{s.lineno}"
        end
      end
    end

    def found_sequence(method_name, location)
      @sequences << Record.new(location.path, location.lineno, starting_method, method_name)
    end

    def decorate
      clazz_to_decorate.class_exec(self) do |my_check|
        @_pippi_method_call_sequences = my_check
        class << self
          attr_reader :_pippi_method_call_sequences
        end
        prepend MyModule
      end
    end

  end
end
