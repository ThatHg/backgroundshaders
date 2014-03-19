Shader "Background/FourButtons"
{
	// This is outside variables i.e. from Unity C# script and what nots.
	Properties
	{
		// Colors
		_col0	("First Color", Color)		= (1,0,0,1)	// Red
		_col1	("Second Color", Color)		= (0,1,0,1)	// Green
		_col2	("Third Color", Color)		= (0,0,1,1)	// Blue
		_col3	("Fourth Color", Color)		= (0,1,1,1)	// Yellow
		
		// Distance between primitives
		_dist	("Displacement", float)		= 0.7
		
		// Zooming
		_zoom	("Zoom", float)				= 150
		
		// General speed
		_speed	("General Speed", float)	= 1
		
		// Music rythm, intensity of music
		_rythm	("Music Rythm", float)		= 1
		
		// Resolution of viewport
		_width	("Viewport Width", float)	= 1
		_height ("Viewport Height", float)	= 1
		
		// Position on screen
		_posx	("Position X", float)		= 1
		_posy	("Position Y", float)		= 1

		// Objects scale
		_scaleh ("Horizontal Scale", float)	= 1
		_scalev	("Vertical Scale", float)	= 1
		
		_iterations ("Frac Val", float)		= 6
	}

	SubShader
	{
		Pass
		{
			Name "Colors"
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma glsl
			#pragma target 3.0
			
			// Denfines for better readability in sourcecode
			#define WHITE float4(1.)
			#define GRAY float4(.3)
			#define BLACK float4(0.)
			#define PI 3.14159265358979
			#define TAU 6.2831853071795
			#define TILE_SIZE float2(60.0)
			#define FOV_MORPH 1

			#include "UnityCG.cginc"
			
			// Outside variables
			float4 	_col0;
			float4 	_col1;
			float4	_col2;
			float4	_col3;
			float	_dist;
			float	_speed;
			float	_zoom;
			float	_rythm;
			float	_width;
			float	_height;
			float	_posx;
			float	_posy;
			float	_scaleh;
			float	_scalev;
			float	_iterations;
			
			float4 get_color(float voronoi)
			{
				if(voronoi < 0.25)
					return _col2;
				else if(voronoi < 0.50 && voronoi >= 0.25)
					return _col1;
				else if(voronoi < 0.75 && voronoi >= 0.50)
					return _col3;
				else
					return _col0;
			}

			float4 pack_F1_UB4(float value )
			{
			    float4 res = frac( value*float4(16777216.0, 65536.0, 256.0, 1.0) );
				res.yzw -= res.xyz/256.0;
				return res;
			}

			float unpack_F1_UB4(float4 value )
			{
			    return dot( value, float4(1.0/16777216.0, 1.0/65536.0, 1.0/256.0, 1.0));
			}
			
			struct VsIn
			{
				float4 vertex : POSITION;
				float4 texcoord0 : TEXCOORD0;
			};

			struct VsOut
			{
				float4 position : SV_POSITION;
				float4 texcoord0 : TEXCOORD0;
			};
			
			VsOut vert(VsIn i)
			{
				VsOut o;
				o.position = mul (UNITY_MATRIX_MVP, i.vertex);
				o.texcoord0 = i.texcoord0 * _zoom;
				return o;
			}

			float4 frag(VsOut i) : COLOR
			{
				float2 uv = i.texcoord0;
	
				float signal = 0.5 + 0.5*sin(uv.x + sin(uv.y) )*sin(uv.y + sin(uv.x+_Time.y) ) + _rythm * 0.02;
				
				// pack float to 8 bit float4
				float4 pa = pack_F1_UB4( signal );

			    // simulate that we are writing to a 8 bit color buffer	
				float4 buff = floor( 256.0*pa );
				
				// simulate that we are reading from a 8 bit color buffer
				float4 unpa = buff / 256.0;

			    // unkack from an 8nit float4, to a float	 
				float f = unpack_F1_UB4( unpa );
				
				return get_color(f);
			}
			ENDCG
		}
	}
}





































