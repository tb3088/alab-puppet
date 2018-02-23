# expose Ruby class constants as Facts

Facter.add(:separator) do
  setcode do
    { 'file' => File::SEPARATOR, 'path' => File::PATH_SEPARATOR }
  end
end