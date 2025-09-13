@echo off
echo 正在启动去水印下载网站服务器...
echo.
echo 服务器地址: http://localhost:8000
echo 网站地址: http://localhost:8000/watermark-remover.html
echo.
echo 按 Ctrl+C 停止服务器
echo.
powershell -Command "Add-Type -AssemblyName System.Web; $listener = New-Object System.Net.HttpListener; $listener.Prefixes.Add('http://localhost:8000/'); $listener.Start(); Write-Host 'HTTP服务器已启动: http://localhost:8000/'; Write-Host '网站地址: http://localhost:8000/watermark-remover.html'; Write-Host '按 Ctrl+C 停止服务器'; Write-Host ''; try { while ($true) { $context = $listener.GetContext(); $request = $context.Request; $response = $context.Response; $url = $request.Url.LocalPath; if ($url -eq '/') { $url = '/watermark-remover.html' }; $filePath = Join-Path $PWD ($url.TrimStart('/')); if (Test-Path $filePath -PathType Leaf) { $content = [System.IO.File]::ReadAllBytes($filePath); $response.ContentLength64 = $content.Length; if ($filePath.EndsWith('.html')) { $response.ContentType = 'text/html; charset=utf-8' } elseif ($filePath.EndsWith('.css')) { $response.ContentType = 'text/css' } elseif ($filePath.EndsWith('.js')) { $response.ContentType = 'application/javascript' } else { $response.ContentType = 'application/octet-stream' }; $response.StatusCode = 200; $response.OutputStream.Write($content, 0, $content.Length) } else { $response.StatusCode = 404; $errorBytes = [System.Text.Encoding]::UTF8.GetBytes('404 - File Not Found'); $response.OutputStream.Write($errorBytes, 0, $errorBytes.Length) }; $response.OutputStream.Close() } } catch { Write-Host \"错误: $_\" } finally { $listener.Stop() }"
pause