from __future__ import annotations
from pathlib import Path
from typing import Dict, List, Tuple, Optional


class AbaqusToFlagshypConverter:
    def __init__(self, inp_file: str):
        self.inp_file = Path(inp_file)

        self.title = "Converted Abaqus model"
        self.element_type = None
        self.nodes: Dict[int, Tuple[float, float, float]] = {}
        self.elements: List[Tuple[int, List[int]]] = []
        self.nsets: Dict[str, List[int]] = {}
        self.materials: List[List[float]] = []

        self.fixed_dofs: Dict[int, set[int]] = {}
        self.prescribed_displacements: List[Tuple[int, int, float]] = []

        self.step_amplitudes: Dict[str, List[Tuple[float, float]]] = {}
        self.pending_boundary_blocks: List[Tuple[Optional[str], List[str]]] = []

        self.youngs_modulus: Optional[float] = None
        self.poisson_ratio: Optional[float] = None
        self.density: Optional[float] = None

    def parse(self) -> None:
        with self.inp_file.open("r", encoding="utf-8", errors="ignore") as f:
            lines = f.readlines()

        i = 0
        while i < len(lines):
            line = lines[i].strip()
            low = line.lower()

            if not line:
                i += 1
                continue

            if low.startswith("*heading"):
                i += 1
                while i < len(lines):
                    txt = lines[i].strip()
                    if txt.startswith("*"):
                        break
                    if txt and not txt.startswith("**"):
                        self.title = txt
                        break
                    i += 1
                continue

            if low.startswith("*node"):
                i = self._parse_nodes(lines, i + 1)
                continue

            if low.startswith("*element"):
                self.element_type = self._extract_param(line, "type")
                i = self._parse_elements(lines, i + 1)
                continue

            if low.startswith("*nset"):
                nset_name = self._extract_param(line, "nset")
                generate = "generate" in low
                i = self._parse_nset(lines, i + 1, nset_name, generate)
                continue

            if low.startswith("*density"):
                i = self._parse_density(lines, i + 1)
                continue

            if low.startswith("*elastic"):
                i = self._parse_elastic(lines, i + 1)
                continue

            if low.startswith("*amplitude"):
                amp_name = self._extract_param(line, "name")
                i = self._parse_amplitude(lines, i + 1, amp_name)
                continue

            if low.startswith("*boundary"):
                amp_name = self._extract_param(line, "amplitude")
                i = self._parse_boundary(lines, i + 1, amp_name)
                continue

            i += 1

        self._finalize_materials()

    def _extract_param(self, line: str, key: str) -> Optional[str]:
        parts = [p.strip() for p in line.split(",")]
        for p in parts:
            if "=" in p:
                k, v = p.split("=", 1)
                if k.strip().lower() == key.lower():
                    return v.strip()
        return None

    def _parse_nodes(self, lines: List[str], i: int) -> int:
        while i < len(lines):
            line = lines[i].strip()
            if not line:
                i += 1
                continue
            if line.startswith("*"):
                break

            vals = [x.strip() for x in line.split(",") if x.strip()]
            if len(vals) >= 4:
                nid = int(vals[0])
                x = float(vals[1])
                y = float(vals[2])
                z = float(vals[3])
                self.nodes[nid] = (x, y, z)
            i += 1
        return i

    def _parse_elements(self, lines: List[str], i: int) -> int:
        while i < len(lines):
            line = lines[i].strip()
            if not line:
                i += 1
                continue
            if line.startswith("*"):
                break

            vals = [x.strip() for x in line.split(",") if x.strip()]
            if len(vals) >= 2:
                eid = int(vals[0])
                conn = [int(v) for v in vals[1:]]
                self.elements.append((eid, conn))
            i += 1
        return i

    def _parse_nset(self, lines: List[str], i: int, nset_name: Optional[str], generate: bool) -> int:
        if not nset_name:
            return i

        if nset_name not in self.nsets:
            self.nsets[nset_name] = []

        while i < len(lines):
            line = lines[i].strip()
            if not line:
                i += 1
                continue
            if line.startswith("*"):
                break

            vals = [x.strip() for x in line.split(",") if x.strip()]
            nums = [int(v) for v in vals]

            if generate and len(nums) >= 3:
                start, stop, step = nums[:3]
                self.nsets[nset_name].extend(range(start, stop + 1, step))
            else:
                self.nsets[nset_name].extend(nums)

            i += 1

        self.nsets[nset_name] = sorted(set(self.nsets[nset_name]))
        return i

    def _parse_density(self, lines: List[str], i: int) -> int:
        while i < len(lines):
            line = lines[i].strip()
            if not line:
                i += 1
                continue
            if line.startswith("*"):
                break
            vals = [x.strip() for x in line.split(",") if x.strip()]
            if vals:
                self.density = float(vals[0])
                return i + 1
            i += 1
        return i

    def _parse_elastic(self, lines: List[str], i: int) -> int:
        while i < len(lines):
            line = lines[i].strip()
            if not line:
                i += 1
                continue
            if line.startswith("*"):
                break
            vals = [x.strip() for x in line.split(",") if x.strip()]
            if len(vals) >= 2:
                self.youngs_modulus = float(vals[0])
                self.poisson_ratio = float(vals[1])
                return i + 1
            i += 1
        return i

    def _parse_amplitude(self, lines: List[str], i: int, amp_name: Optional[str]) -> int:
        if not amp_name:
            return i

        data: List[Tuple[float, float]] = []
        while i < len(lines):
            line = lines[i].strip()
            if not line:
                i += 1
                continue
            if line.startswith("*"):
                break

            vals = [x.strip() for x in line.split(",") if x.strip()]
            nums = [float(v) for v in vals]
            for j in range(0, len(nums) - 1, 2):
                data.append((nums[j], nums[j + 1]))
            i += 1

        self.step_amplitudes[amp_name] = data
        return i

    def _parse_boundary(self, lines: List[str], i: int, amp_name: Optional[str]) -> int:
        block: List[str] = []
        while i < len(lines):
            line = lines[i].strip()
            if not line:
                i += 1
                continue
            if line.startswith("*"):
                break
            block.append(line)
            i += 1

        self._process_boundary_block(block, amp_name)
        return i

    def _process_boundary_block(self, block: List[str], amp_name: Optional[str]) -> None:
        scale = 1.0
        if amp_name and amp_name in self.step_amplitudes and self.step_amplitudes[amp_name]:
            scale = self.step_amplitudes[amp_name][-1][1]

        for line in block:
            vals = [x.strip() for x in line.split(",") if x.strip()]
            if len(vals) < 3:
                continue

            target = vals[0]
            dof1 = int(vals[1])
            dof2 = int(vals[2])
            value = float(vals[3]) if len(vals) >= 4 else 0.0
            value *= scale

            if target in self.nsets:
                node_ids = self.nsets[target]
            else:
                try:
                    node_ids = [int(target)]
                except ValueError:
                    continue

            for nid in node_ids:
                if value == 0.0:
                    if nid not in self.fixed_dofs:
                        self.fixed_dofs[nid] = set()
                    for dof in range(dof1, dof2 + 1):
                        self.fixed_dofs[nid].add(dof)
                else:
                    for dof in range(dof1, dof2 + 1):
                        self.prescribed_displacements.append((nid, dof, value))
                        if nid not in self.fixed_dofs:
                            self.fixed_dofs[nid] = set()
                        self.fixed_dofs[nid].add(dof)

    def _finalize_materials(self) -> None:
        if self.density is None:
            self.density = 7800.0
        if self.youngs_modulus is None:
            self.youngs_modulus = 2.0e11
        if self.poisson_ratio is None:
            self.poisson_ratio = 0.3

        mu = self.youngs_modulus / (2.0 * (1.0 + self.poisson_ratio))
        lam = self.youngs_modulus * self.poisson_ratio / (
            (1.0 + self.poisson_ratio) * (1.0 - 2.0 * self.poisson_ratio)
        )

        # FLAGSHyP material type 1: compressible neo-Hookean
        self.materials = [[1, 1, self.density, mu, lam]]

    def flagshyp_element_name(self) -> str:
        if self.element_type:
            et = self.element_type.upper()
            if et.startswith("C3D8"):
                return "hexa8"
            if et.startswith("C3D4"):
                return "tetr4"
        if self.elements and len(self.elements[0][1]) == 8:
            return "hexa8"
        if self.elements and len(self.elements[0][1]) == 4:
            return "tetr4"
        raise ValueError("Unsupported element type")

    def bc_code(self, nid: int) -> int:
        dofs = self.fixed_dofs.get(nid, set())
        has_x = 1 in dofs
        has_y = 2 in dofs
        has_z = 3 in dofs

        if not has_x and not has_y and not has_z:
            return 0
        if has_x and not has_y and not has_z:
            return 1
        if not has_x and has_y and not has_z:
            return 2
        if has_x and has_y and not has_z:
            return 3
        if not has_x and not has_y and has_z:
            return 4
        if has_x and not has_y and has_z:
            return 5
        if not has_x and has_y and has_z:
            return 6
        if has_x and has_y and has_z:
            return 7

        return 0

    def write_flagshyp(self, out_file: str) -> None:
        out = Path(out_file)

        n_point_loads = 0
        n_prescribed = len(self.prescribed_displacements)
        n_pressure_loads = 0
        gravity = (0.0, 0.0, 0.0)

        with out.open("w", encoding="utf-8") as f:
            f.write(f"{self.title}\n")
            f.write(f"{self.flagshyp_element_name()}\n")

            f.write(f"{len(self.nodes)}\n")
            for nid in sorted(self.nodes):
                x, y, z = self.nodes[nid]
                f.write(f"{nid} {self.bc_code(nid)} {x:.9g} {y:.9g} {z:.9g}\n")

            f.write(f"{len(self.elements)}\n")
            for eid, conn in self.elements:
                conn_txt = " ".join(str(n) for n in conn)
                f.write(f"{eid} 1 {conn_txt}\n")

            f.write(f"{len(self.materials)}\n")
            for mat in self.materials:
                f.write(" ".join(f"{v:.9g}" if isinstance(v, float) else str(v) for v in mat) + "\n")

            f.write(f"{n_point_loads} {n_prescribed} {n_pressure_loads} "
                    f"{gravity[0]:.9g} {gravity[1]:.9g} {gravity[2]:.9g}\n")

            # item 10: nodal loads
            # none

            # item 11: prescribed displacements
            for nid, dof, value in self.prescribed_displacements:
                f.write(f"{nid} {dof} {value:.9g}\n")

            # item 12: pressure loads
            # none

            # item 13: control information
            f.write("1 1.0 1 25 1e-6 0.0 0.0 0 0 0 0\n")


def convert_abaqus_to_flagshyp(inp_file: str, out_file: str) -> None:
    conv = AbaqusToFlagshypConverter(inp_file)
    conv.parse()
    conv.write_flagshyp(out_file)


if __name__ == "__main__":
    convert_abaqus_to_flagshyp("Job-1.inp", "explicit_100elt_3D.dat")
