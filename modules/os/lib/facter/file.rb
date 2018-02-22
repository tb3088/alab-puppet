# expose Ruby class constants as Facts

Facter.add(:file) do
  setcode do
    { 'separator' => File::SEPARATOR, 'path_separator' => File::PATH_SEPARATOR }
  end
end