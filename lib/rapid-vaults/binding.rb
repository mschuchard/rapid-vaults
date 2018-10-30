# class to output bindings with other software
class Binding
  # outputs puppet bindings
  def self.puppet(settings)
    # output puppet bindings to output directory
    %w[gpg ssl].each do |algo|
      %w[encrypt decrypt].each do |action|
        content = File.read("#{__dir__}/bindings/puppet_#{algo}_#{action}.rb")
        File.write("#{settings[:outdir]}puppet_#{algo}_#{action}.rb", content)
      end
    end
  end

  # outputs chef bindings
  def self.chef(settings)
    # output chef bindings to output directory
    content = File.read("#{__dir__}/bindings/chef.rb")
    File.write("#{settings[:outdir]}chef.rb", content)
  end
end
