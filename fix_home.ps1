$file = 'd:\project\flutter\flutter_application_ecommerce\lib\features\home\presentation\screens\home_screen.dart'
$content = [System.IO.File]::ReadAllText($file)

# The horizontal card Container is missing proper indent (child directly unindented under GestureDetector child:)
# Pattern: `child: Container(\r\n      width: 155,` -> fix to `child: Container(\r\n        width: 155,`
$old1 = "      child: Container(`r`n      width: 155,"
$new1 = "      child: Container(`r`n        width: 155,"
$content = $content.Replace($old1, $new1)

# The horizontal card closes: `],`n      ),`n    );`n  }` -> need `],`n      ),`n    ),`n    );`n  }`
# The horizontal card ends same way as grid; identify by the unique text near the end of _buildProductCardHorizontal
# It ends with the sold text: `' (${p.sold})'` which is uniquely inside closing of horizontal card
# Fix: replace `],\r\n                ),\r\n              ],\r\n            ),\r\n          ),\r\n        ],\r\n      ),\r\n    );\r\n  }\r\n\r\n\r\n  // -- SPECIAL` with correctly closed GD version
$oldEnd = "    `],`r`n                ),`r`n              ],`r`n            ),`r`n          ),`r`n        ],`r`n      ),`r`n    );`r`n  }`r`n`r`n`r`n  // -- SPECIAL"

Write-Host "Script loaded. Content length: $($content.Length)"
Write-Host "Saving file..."
[System.IO.File]::WriteAllText($file, $content)
Write-Host "Done"
