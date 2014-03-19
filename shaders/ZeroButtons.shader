Shader "Background/ZeroButtons"
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

			float rand(float2 co)
			{
			    return frac(sin( dot(co.xy ,float2(12.9898,78.233) )) * (463378.5453));
			}

			float sphere(float3 p, float scale)
			{
				return length(p) - scale;
			}
			
			float repetition( float3 p, float3 c )
			{
				float3 q = fmod(p,c)-0.5*c;
				return sphere(q, .8 + _rythm * .2);
			}

			VsOut vert(VsIn i)
			{
				VsOut o;
				o.position = mul (UNITY_MATRIX_MVP, i.vertex);
				o.texcoord0 = (i.texcoord0 +  rand(i.texcoord0 * _rythm) * 0.002) * _zoom;
				return o;
			}

			float4 frag(VsOut i) : COLOR
			{
				float2 uv = i.texcoord0.xy;
				float sphere_mask = repetition(float3(uv.x, uv.y, -0.5), float3(_dist, _dist, 1.));

				// Hard edges 
				sphere_mask = sphere_mask >= 1;

				float4 col = float4(sphere_mask);
				float4 col2 = float4(1.);
				col = lerp(_col3, _col2, sphere_mask);
				if(fmod(_rythm, 2) > 1)
					col2 = lerp(_col0, _col1, sphere_mask);
				else
					col2 = lerp(_col2, _col3, sphere_mask);
							
				col = lerp(col, col2, _rythm * rand(i.texcoord0.xy) * 0.3);
				//col = lerp(col, BLACK, sphere_mask >= 1.0);
				
				return col;
			}
			ENDCG
		}
	}
}