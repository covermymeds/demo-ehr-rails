class Formulary

  BANANA = 'banana'.freeze

  def self.pa_required?(prescriptions)
    # In the future we'll call out to the formulary service, but for now we
    # require PAs for banana drugs, otherwise we do not require them.
    prescriptions.map { |p| p.merge(autostart: p[:name].downcase.include?(BANANA)) }
  end

end
