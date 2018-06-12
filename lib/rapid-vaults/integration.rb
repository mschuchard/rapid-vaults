# class to output integrations with other software
class Integration
  # outputs puppet integrations
  def self.puppet(settings)
    # output puppet integrations to output directory
    %w[gpg ssl].each do |algo|
      %w[encrypt decrypt].each do |action|
        content = File.read("#{__dir__}/integrations/puppet_#{algo}_#{action}.rb")
        File.write("#{settings[:outdir]}puppet_#{algo}_#{action}.rb", content)
      end
    end
  end
end
