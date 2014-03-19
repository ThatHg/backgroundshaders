Shader "Background/OneButtons"
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
		_dist	("Distance", float)			= 3.7
		
		// Zooming
		_zoom	("Zoom", float)				= 1
		
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
			#define	WAVES 20

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
			float	_distance;
			
			float rand(float2 co)
			{
			    return frac(sin( dot(co.xy ,float2(12.9898,78.233) )) * (463378.5453));
			}

			float sphere(float3 p, float scale)
			{
				return length(p) - scale;
			}
			
			float box( float3 p, float3 b )
			{
				return length(max(abs(p)-b,0.0));
			}
			
			float repetition( float3 p, float3 c )
			{
				float3 q = fmod(p,c)-0.5*c;
				return box(q, c);//1 + _rythm * .5);
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
				o.texcoord0 = (i.texcoord0)* (_zoom);
				return o;
			}

			float4 frag(VsOut i) : COLOR
			{
				float2 uv = i.texcoord0;
				
				uv.x = -1.0 - uv.x;
				uv.y += sin(uv.x*10.0+_Time.y)/10.0;
				
				float sphere_mask = repetition(float3(uv.x, uv.y, -0.5), float3(_dist, _dist, 1.));
				
				// Hard edges 
				if(sphere_mask >= 0.17 + _rythm * 0.01)
					sphere_mask = 1.;
				else
					sphere_mask = .5;

				float4 color = float4(sphere_mask);
				color = lerp(BLACK, _col0, sphere_mask);
				
				return color;
			}		
			ENDCG
		}
	}
}