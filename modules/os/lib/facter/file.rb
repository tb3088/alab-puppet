# expose Ruby class constants as Facts

separator = { 'file' => File::SEPARATOR, 'path' => File::PATH_SEPARATOR }

Facter.add(:separator) do
  setcode { separator }
end

# BUG: facter ignores has_weight, so can't override built-in
# see https://tickets.puppetlabs.com/browse/FACT-1528
Facter.add(:os_extended) do
#  has_weight 99
  setcode { Facter.value(:os).merge({ 'separator' => separator }) }
end