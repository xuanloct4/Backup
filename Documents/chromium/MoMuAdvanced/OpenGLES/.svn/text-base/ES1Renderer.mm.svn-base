//
//  ES1Renderer.m
//  MoMuAdvanced
//
//  Created by Jorge Herrera on 6/10/10.
//  Copyright Stanford 2010. All rights reserved.
//

#include "ES1Renderer.h"
#include "mo_gfx.h"
#include "mo_audio.h"
#include "mo_thread.h"
#include "mo_fft.h"
#include <cmath>

#define FRAMESIZE (256)
#define DRAWSIZE (FRAMESIZE*2)
#define SRATE (16000)


GLfloat g_vertices[DRAWSIZE];
GLfloat g_verticesCopy[DRAWSIZE];
GLfloat g_freqVertices[FRAMESIZE];
MoMutex g_mutex;
GLint g_displayMode = 0;


//-----------------------------------------------------------------------------
// name: audioCallback()
// desc: callback function for audio
//-----------------------------------------------------------------------------
void audioCallback( Float32 * buffer, UInt32 frameSize, void * userData )
{
	float start = -1.5;
	float inc = (3.0)/frameSize;
	
	// loop over nframes
	for( int i = 0; i < frameSize; i++ )
	{
		//NSLog(@"%f",start );
	
		g_vertices[i*2] = start; //TODO precompute me only once
		g_vertices[i*2+1] = buffer[2*i]; 
		
		// Increment the 
		start += inc;
	
		// Pack Mono input into the first half of the buffer for the fft
		buffer[i] = buffer[2*i];

	}
	
	//lock
	g_mutex.acquire();
	
		//Copy buffer
		memcpy(g_verticesCopy, g_vertices, DRAWSIZE*sizeof(GLfloat));
	
		// Compute fft from the original audio buffer
        MoFFT::rfft( buffer, frameSize, FFT_FORWARD );
	
		// Cast as a complex buffer
		complex * fftSamples = (complex *)buffer;
	
		// compute the magnitude
	    start = -1.5;
	    inc = (3.0)/(frameSize/2.0);

		for(int i=0; i < frameSize/2; i++)
		{
			//Compute dB
			float mag = 20.0*log10(cmp_abs(fftSamples[i]));
			
			// Normalize for display
			mag = (mag + 50.0)/50.0;
			
			g_freqVertices[i*2] = start;
			g_freqVertices[i*2+1] = mag;
			
			// Increment 
			start += inc;
		}
	

	// unlock
	g_mutex.release();
	
	// Clear the audio buffer so there won't be any feedback
	memset(buffer, 0, (frameSize*2)*sizeof(Float32));
	
}



void initEverything()
{
	
	// Init the graphics
	
	//Clear the vertices
	memset(g_vertices, 0, DRAWSIZE*sizeof(GLfloat));
	memset(g_verticesCopy, 0, DRAWSIZE*sizeof(GLfloat));
	memset(g_freqVertices, 0, FRAMESIZE*sizeof(GLfloat));
	
	
	// Init the audio
	
	// log
    NSLog( @"starting real-time audio..." );
    
    // init the audio layer
    bool result = MoAudio::init( SRATE, FRAMESIZE, 2 );
    if( !result )
    {
        // something went wrong
        NSLog( @"cannot initialize real-time audio!" );
        // bail out
		return;
    }
    
    // start the audio layer, registering a callback method
    result = MoAudio::start( audioCallback, NULL );
    if( !result )
    {
        // something went wrong
        NSLog( @"cannot start real-time audio!" );
        // bail out
		return;
    }	
	
}

void renderTimeDomain()
{
	
	//Set the vertex up to draw
	glVertexPointer(2, GL_FLOAT, 0, g_vertices);
	glEnableClientState(GL_VERTEX_ARRAY);
	
	
	//Render the circle
    glPushMatrix();
	
	// translate
	//glTranslatef( 0.0, 0.0, 0.0 );
	
	// scale
	// glScalef( 1.0, 1.0, 1.0 );
	
	// Region 1
	glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
	
	glLineWidth(2.0);
	
	glDrawArrays(GL_LINE_STRIP, 0, FRAMESIZE);
	
	// pop	
	glPopMatrix();
	
	// go back to normal state
	glDisableClientState(GL_VERTEX_ARRAY);
	
}

void renderFrequencyDomain()
{
	//Set the vertex up to draw
	glVertexPointer(2, GL_FLOAT, 0, g_freqVertices);
	glEnableClientState(GL_VERTEX_ARRAY);
	
	//Render the circle
    glPushMatrix();
	
	// translate
	//glTranslatef( 0.0, 0.0, 0.0 );
	
	// scale
	// glScalef( 1.0, 1.0, 1.0 );
	
	// Region 1
	glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
	
	glLineWidth(2.0);
	
	glDrawArrays(GL_LINE_STRIP, 0, FRAMESIZE/2);
	
	// pop	
	glPopMatrix();
	
	// go back to normal state
	glDisableClientState(GL_VERTEX_ARRAY);	
	
}

void render_audio_buffer()
{
	
	glClearColor( 0.0f, 0.0f, 0.0f, 1.0f );
    glClear( GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT );


	if(g_displayMode==0)
		renderTimeDomain();
	else
		renderFrequencyDomain();
	

}


@implementation ES1Renderer

- (void)updateDisplayMode:(NSNotification *)notification
{
	
	NSString * mode = [[notification userInfo] objectForKey:@"mode"];
	
	if( [mode compare:@"time"] )
		g_displayMode = 1;
	else
		g_displayMode = 0;
	
}


// Create an ES 1.1 context
- (id) init
{
	if (self = [super init])
	{
		context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
        
        if (!context || ![EAGLContext setCurrentContext:context])
		{
            [self release];
            return nil;
        }
		
		// Create default framebuffer object. The backing will be allocated for the current layer in -resizeFromLayer
		glGenFramebuffersOES(1, &defaultFramebuffer);
		glGenRenderbuffersOES(1, &colorRenderbuffer);
		glBindFramebufferOES(GL_FRAMEBUFFER_OES, defaultFramebuffer);
		glBindRenderbufferOES(GL_RENDERBUFFER_OES, colorRenderbuffer);
		glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, colorRenderbuffer);
	}
	
	// init the notification center
	[[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(updateDisplayMode:) name:(NSString *)@"updateDisplay" object:nil ];
 

 	
	initEverything();
	
	return self;
}

- (void) render
{
	// This application only creates a single context which is already set current at this point.
	// This call is redundant, but needed if dealing with multiple contexts.
    [EAGLContext setCurrentContext:context];
	
	// This application only creates a single default framebuffer which is already bound at this point.
	// This call is redundant, but needed if dealing with multiple framebuffers.
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, defaultFramebuffer);
    glViewport(0, 0, backingWidth, backingHeight);
	
    // set projection
    MoGfx::perspective( 60, (GLfloat)backingWidth/backingHeight, .1, 100 );
	
    // set modelview back to identity
    glMatrixMode( GL_MODELVIEW );
	glLoadIdentity();
    // look
    MoGfx::lookAt( 0, 0, 3, 0, 0, 0, 1, 0, 0 );
    
    // enable depth test
    glEnable( GL_DEPTH_TEST );
	glDepthFunc( GL_LEQUAL );
	glDepthMask( GL_TRUE );
    
    // call gamelan render
    render_audio_buffer();
    
	// This application only creates a single color renderbuffer which is already bound at this point.
	// This call is redundant, but needed if dealing with multiple renderbuffers.
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, colorRenderbuffer);
	[context presentRenderbuffer:GL_RENDERBUFFER_OES];

}

- (BOOL) resizeFromLayer:(CAEAGLLayer *)layer
{	
	// Allocate color buffer backing based on the current layer size
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, colorRenderbuffer);
    [context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:layer];
	glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);
	
    if (glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES)
	{
		NSLog(@"Failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
        return NO;
    }
    
    return YES;
}

- (void) dealloc
{
	// Tear down GL
	if (defaultFramebuffer)
	{
		glDeleteFramebuffersOES(1, &defaultFramebuffer);
		defaultFramebuffer = 0;
	}

	if (colorRenderbuffer)
	{
		glDeleteRenderbuffersOES(1, &colorRenderbuffer);
		colorRenderbuffer = 0;
	}
	
	// Tear down context
	if ([EAGLContext currentContext] == context)
        [EAGLContext setCurrentContext:nil];
	
	[context release];
	context = nil;
	
	[super dealloc];
}

@end
