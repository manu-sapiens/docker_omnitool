const express = require('express');
const { createProxyMiddleware } = require('http-proxy-middleware');
const { spawn , execSync} = require('child_process');
const fs = require('fs');

const app = express();

const OMNI_URL = 'http://127.0.0.1:1688'; // URL of the OMNITOOL service
const PROXY_PORT_OMNITOOL = 4444;
const OMNITOOL_INSTALL_SCRIPT = './omnitool_init.sh'; // './omnitool_start.sh';

// Define the proxy middleware
const omnitoolProxyMiddleware = createProxyMiddleware({
    target: OMNI_URL,
    changeOrigin: true,
    ws: true // if you need WebSocket support
});

// Use the proxy middleware
app.use(omnitoolProxyMiddleware);

// Start the server on port 4444
app.listen(PROXY_PORT_OMNITOOL, () => {
    console.log(`Server running on port ${PROXY_PORT_OMNITOOL}`);
});

function readFromPipe() 
{
    console.log('Reading from pipe')
    const readStream = fs.createReadStream('./tmp/logpipe', 'utf8');
    readStream.on('data', (chunk) => {
        console.log(`[pipe] ${chunk}`);
    });
}          
async function startOmnitoolServer()
{
    
    console.log('Starting Omnitool Server...');
    return new Promise((resolve, reject) =>
    {

        // check if the named pipe exists
        if (fs.existsSync('./tmp/logpipe') == false)
        {
            // Create the named pipe
            execSync('mkfifo ./tmp/logpipe');
        }
        else
        {
            console.log('Pipe exists');
        }

        const omnitoolStartProcess = spawn(OMNITOOL_INSTALL_SCRIPT);
        omnitoolStartProcess.stdout.on('data', (data) =>
        {
            console.log(`[log] ${data}`);    
        });

        omnitoolStartProcess.stderr.on('data', (data) =>
        {
            console.error(`[stderr] ${data}`);
        });

        omnitoolStartProcess.on('spawn', () => {
            console.log('Omnitool server process started. Reading from pipe');
            readFromPipe();
        });

        omnitoolStartProcess.on('close', (code) =>
        {
            const message = `Omnitool server process exited with code: ${code}`;
            console.log(message);
            if (code === 0)
            {
                //@ts-ignore
                resolve();
            } else
            {
                reject(`Omnitool server did not start properly.`);
            }
        });
    });
}

async function main(app)
{
    try
    {
        await startOmnitoolServer();
        console.log('Omnitool server started successfully');
    } catch (error)
    {
        console.error(error);
    }
}

main(app);
