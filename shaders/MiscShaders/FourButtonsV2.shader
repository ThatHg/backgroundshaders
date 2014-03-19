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

		// Objects scale
		_scaleh ("Horizontal Scale", float)	= 1
		_scalev	("Vertical Scale", float)	= 1
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
			
			float4 get_color(float3 voronoi)
			{
				if(voronoi.x < 0.20)
					return _col0;
				else if(voronoi.x < 0.40 && voronoi.x >= 0.20)
					return _col1;
				else if(voronoi.x < 0.80 && voronoi.x >= 0.40)
					return _col2;
				else
					return _col3;
			}
			
			float rand(float2 co)
			{
			    return frac(sin( dot(co.xy ,float2(12.9898,78.233) )) * (463378.5453));
			}
			
			float3 Voronoi( float3 pos )
			{
				float3 d[8];
				d[0] = float3(0,0,0);
				d[1] = float3(1,0,0);
				d[2] = float3(0,1,0);
				d[3] = float3(1,1,0);
				d[4] = float3(0,0,1);
				d[5] = float3(1,0,1);
				d[6] = float3(0,1,1);
				d[7] = float3(1,1,1);
				
				float closest = 12.0;
				float4 result;
				for ( int i=0; i < 8; i++ )
				{
					float4 r = rand(float2(floor(pos+d[i])));
					float3 p = d[i] + _dist * (r.xyz-.5);
					p -= frac(pos);
					float lsq = dot(p,p);
					if ( lsq < closest )
					{
						closest = lsq;
						result = r;
					}
				}
				return frac(result.xyz+result.www); // random colour
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
				float2 uv = i.texcoord0.xy;
	
				float3 pos = float3(uv - _rythm * 0.01, _Time.y);

				// not random enough, so rotate diagonally
				pos.yz = pos.yz*cos(TAU/8.0 )+sin(TAU/(8.0))*float2(0.5,-1 + _rythm * 0.01)*pos.zy;
				pos.xz = pos.xz*cos(TAU/8.0)+sin(TAU/8.0)*float2(0.5 + _rythm * 0.0011,-0.3 + _rythm)*pos.zx;
								
				return get_color(Voronoi(pos));
			}
			ENDCG
		}
	}
}