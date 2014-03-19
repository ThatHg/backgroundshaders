Shader "Background/TwoButtons"
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
			#define PI 3.14159265358979
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

			float min(float a, float b)
			{
				if(a < b)
					return a;
				else
					return b;
			}

			float circles_mask(float2 uv, float phase)
			{
				float r = lerp(0.414213562373095, 1.0, phase);
				float l = length(fmod(uv, 1.0) * 2 - 1.0) - r;
				//float fw = (abs(ddx(l)) + abs(ddy(l)))*0.5;
	
				return smoothstep(_SinTime.y, -_SinTime.y, l) + min(l/r*0.5, 0.0);
			}
			
			VsOut vert(VsIn i)
			{
				VsOut o;
				o.position = mul (UNITY_MATRIX_MVP, i.vertex);
				o.texcoord0 = (i.texcoord0 + 0.5) * _zoom;
				return o;
			}

			float4 frag(VsOut i) : COLOR
			{
				float2 uv = i.texcoord0.xy;
				float t0 = _Time.y * _speed + _rythm * 0.1;
				float t = t0 +
				length(6.0*sin(t0*float2(-0.5,  0.9) + 0.5*uv)) +
				length(6.0*sin(t0*float2( 0.2, -0.7) + 0.5*uv));
	
				float phase1 = sin(t);
				float mask1 = circles_mask(uv, phase1);
	
				float phase2 = sin(t + PI);
				float mask2 = circles_mask(uv + 0.5, phase2);
	
				float4 color = _col0;
				//color = lerp(color,	_col0, (mask1 > 0.5));
				color = lerp(color, _col1, (mask1 > 0.5));
				
				
				return color;
			}
			ENDCG
		}
	}
}